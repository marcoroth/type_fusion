# frozen_string_literal: true

require "singleton"

module TypeFusion
  class Sampler
    include Singleton

    attr_accessor :samples

    def initialize
      @samples = []
    end

    def with_sampling
      trace.enable

      yield if block_given?

      trace.disable
    end

    def trace
      @trace ||= TracePoint.trace(:return) do |tracepoint|
        if sample?(tracepoint.path)
          receiver = begin
            tracepoint.binding.receiver.name
          rescue StandardError
            tracepoint.binding.receiver.class.name
          end

          method_name = tracepoint.method_id
          location = tracepoint.binding.source_location.join(":")
          args = tracepoint.parameters.to_h(&:reverse)
          parameters = extract_parameters(args, tracepoint.binding)
          return_value = type_for_object(tracepoint.return_value)

          if TypeFusion.config.gem_mode
            gem, version = gem_and_version_from_disk(location)
          else
            gem, version = gem_and_version_from_binding(location)
          end

          sample_values = {
            gem_name: gem,
            gem_version: version,
            receiver: receiver,
            method_name: method_name,
            application_name: TypeFusion.config.application_name,
            location: location,
            type_fusion_version: VERSION,
            parameters: parameters,
            return_value: return_value,
          }

          sample = SampleCall.new(*sample_values.values)

          samples << sample

          begin
            SampleJob.perform_async(sample)
          rescue StandardError => e
            puts "[TypeFusion] Couldn't enqueue sample: #{e.inspect}"
          end
        end
      end.tap(&:disable)
    end

    def to_s
      inspect
    end

    def inspect
      "#<TypeFusion::Sampler sample_count=#{@samples.count}>"
    end

    def reset!
      @samples = []
      @trace = nil
    end

    private

    def sample?(tracepoint_path)
      TypeFusion.config.type_sample_call? &&
        TypeFusion.config.type_sample_tracepoint_path?(tracepoint_path) &&
        (tracepoint_path.start_with?(gem_path) || TypeFusion.config.gem_mode)
    end

    def type_for_object(object)
      case object
      when Hash
        ["Hash", object.map { |key, value| [key, type_for_object(value)] }]
      when Array
        ["Array", object.map { |value| type_for_object(value) }]
      else
        object.class
      end
    end

    def gem_and_version_from_binding(location)
      gem_and_version = location.gsub(gem_path, "").split("/").first

      return [] if gem_and_version.nil?

      splits = gem_and_version.split("-")

      if splits.length == 1
        [splits.first, nil]
      elsif splits.length == 2
        splits
      else
        *name, version = splits

        # TODO: there must be a better way to do this
        if ["darwin", "java", "linux", "ucrt", "mingw32"].include?(version)
          amount = (version == "ucrt") ? 3 : 2

          version = [*name.pop(amount), version].join("-")
        end

        gem = name.join("-")

        [gem, version]
      end
    end

    def gem_and_version_from_disk(location)
      parts = location.split(":").first.split("/")

      start_pos = 0
      end_pos = parts.length - 1

      parts.each_with_index do |file, index|
        end_pos -= 1
        path = parts[start_pos..end_pos]

        gemspecs = Dir.glob((path + ["*.gemspec"]).join("/"))

        if gemspecs.any?
          root_path = path.join("/")

          gemspec = gemspecs.first
          gem_name = gemspec.split("/").last.split(".").first

          version_file_path = root_path + "/lib/#{gem_name}/version.rb"
          version_regex = /VERSION\s+=\s+['"](.+)['"]/

          if File.exist?(version_file_path)
            version_file = File.read(version_file_path)
            version = version_file.scan(version_regex).flatten.first

            return [gem_name, version]
          end

          return [gem_name, nil]
        end
      end
    end

    def extract_parameters(args, binding)
      args.map do |name, kind|
        variable = name.to_s.gsub("*", "").gsub("&", "").to_sym

        type = if binding.local_variables.include?(variable)
                 type_for_object(binding.local_variable_get(variable))
               else
                 # *, ** or &
                 "unused"
               end

        [name, kind, type]
      end
    end

    def gem_path
      "#{Gem.default_path.last}/gems/"
    end
  end
end
