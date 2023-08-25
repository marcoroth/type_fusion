# frozen_string_literal: true

TypeFusion.start

Minitest.after_run do
  TypeFusion.stop
  TypeFusion.processor.process!
end
