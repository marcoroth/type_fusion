# frozen_string_literal: true

require "singleton"

module TypeFusion
  class Sampler
    include Singleton

    attr_accessor :samples

    def initialize
      @samples = []
      @litejob_server ||= Litejob::Server.new([["default", 1]])
    end

    def with_sampling
      trace.enable

      yield if block_given?

      trace.disable
    end

    def trace
      @trace ||= TracePoint.trace(:call) do |tracepoint|
        if sample?(tracepoint.path)
          receiver = begin
            tracepoint.binding.receiver.name
          rescue StandardError
            tracepoint.binding.receiver.class.name
          end

          method_name = tracepoint.method_id
          location = tracepoint.binding.source_location
          gem_and_version = location.first.gsub(gem_path, "").split("/").first
          args = tracepoint.parameters.to_h(&:reverse)
          parameters = extract_parameters(args, tracepoint.binding)

          sample = SampleCall.new(
            gem_and_version: gem_and_version,
            receiver: receiver,
            method_name: method_name,
            location: location,
            parameters: parameters,
          )

          samples << sample
          SampleJob.perform_async(sample)
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
        tracepoint_path.start_with?(gem_path)
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
