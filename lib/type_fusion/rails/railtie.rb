# frozen_string_literal: true

module TypeFusion
  class Railtie < ::Rails::Railtie
    initializer "type_fusion.middleware" do |app|
      require "type_fusion/rack/middleware"

      TypeFusion.config.application_name = app.class.module_parent_name

      app.config.middleware.use TypeFusion::Middleware
    end
  end
end
