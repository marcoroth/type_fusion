# frozen_string_literal: true

require_relative "../type_fusion"

TypeFusion.start

Minitest.after_run do
  TypeFusion.stop
  TypeFusion.processor.process!
end
