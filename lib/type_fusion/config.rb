# frozen_string_literal: true

require "singleton"

module TypeFusion
  class << self
    def config
      @config ||= Config.instance

      yield @config if block_given?

      @config
    end
    alias configure config
  end

  class Config
    include Singleton

    attr_accessor :type_sample_call_rate, :type_sample_request, :type_sample_tracepoint_path, :endpoint, :application_name

    def initialize
      @type_sample_call_rate = 0.001
      @type_sample_request = ->(_env) { [true, false, false, false].sample }
      @type_sample_tracepoint_path = ->(_tracepoint_path) { true }
      @endpoint = "https://gem.sh/api/v1/types/samples"
      @application_name = "TypeFusion"
    end

    def type_sample_request?(env)
      type_sample_request&.call(env)
    end

    def type_sample_tracepoint_path?(env)
      type_sample_tracepoint_path&.call(env)
    end

    def type_sample_call?
      type_sample_call_rate > rand
    end
  end
end
