# frozen_string_literal: true

require_relative "type_fusion/version"
require_relative "type_fusion/config"
require_relative "type_fusion/client"
require_relative "type_fusion/litejob"
require_relative "type_fusion/sample_call"
require_relative "type_fusion/sample_job"
require_relative "type_fusion/sampler"
require_relative "type_fusion/processor"

module TypeFusion
  class << self
    def start
      return if Sampler.instance.trace.enabled?

      puts "[TypeFusion] Starting Sampler..."
      Sampler.instance.trace.enable
    end

    def stop
      return unless Sampler.instance.trace.enabled?

      puts "[TypeFusion] Stopping Sampler..."
      Sampler.instance.trace.disable
    end

    def start_processing
      puts "[TypeFusion] Start processing..."
      processor.start!
    end

    def stop_processing
      puts "[TypeFusion] Stop processing..."
      processor.stop!
    end

    def with_sampling
      start

      yield if block_given?

      stop
    end

    def processor
      @processor ||= TypeFusion::Processor.new(4)
    end
  end
end

require_relative "type_fusion/rails/railtie" if defined?(Rails::Railtie)
