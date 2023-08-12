# frozen_string_literal: true

require "singleton"
require "json"

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
      @trace ||= TracePoint.trace(:call) do |tracepoint|
        if tracepoint.path.start_with?(gem_path)
          receiver = begin
            tracepoint.binding.receiver.name
          rescue StandardError
            tracepoint.binding.receiver.class.name
          end

          method_name = tracepoint.method_id
          location = tracepoint.binding.source_location
          gem_and_version = location.first.gsub(gem_path, "").split("/").first
          args = tracepoint.parameters.map(&:reverse).to_h

          parameters = args.map { |name, kind| [name, kind, type_for_object(tracepoint.binding.local_variable_get(name))] }

          samples << SampleCall.new(
            gem_and_version: gem_and_version,
            receiver: receiver,
            method_name: method_name,
            location: location,
            parameters: parameters,
          )
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

    def gem_path
      "#{Gem.default_path.last}/gems/"
    end
  end
end
