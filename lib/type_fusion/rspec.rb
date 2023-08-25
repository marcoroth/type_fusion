# frozen_string_literal: true

require_relative "../type_fusion"

TypeFusion.start

RSpec.configure do |config|
  config.after(:suite) do
    TypeFusion.stop
    TypeFusion.processor.process!
  end
end
