# frozen_string_literal: true

module TypeFusion
  class Railtie < ::Rails::Railtie
    initializer "type_fusion.middleware" do |app|
      require "type_fusion/rack/middleware"

      app.config.middleware.use TypeFusion::Middleware
    end
  end
end
