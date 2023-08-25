# frozen_string_literal: true

TypeFusion.start

RSpec.configure do |config|
  config.after(:suite) do
    TypeFusion.stop
    TypeFusion.processor.process!
  end
end
