# frozen_string_literal: true

require "type_fusion/sampler"

module TypeFusion
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      if TypeFusion.config.type_sample_request?(env)
        puts "[TypeFusion] Type-sampling this request"
        TypeFusion.start
      end

      @app.call(env)
    ensure
      TypeFusion.stop
    end
  end
end
