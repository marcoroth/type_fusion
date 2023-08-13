# frozen_string_literal: true

require_relative "type_fusion/version"
require_relative "type_fusion/config"
require_relative "type_fusion/litejob"
require_relative "type_fusion/sample_call"
require_relative "type_fusion/sample_job"
require_relative "type_fusion/sampler"

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

    def with_sampling
      start

      yield if block_given?

      stop
    end
  end
end

require_relative "type_fusion/rails/railtie" if defined?(Rails::Railtie)
