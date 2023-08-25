# frozen_string_literal: true

namespace :type_fusion do
  desc "Process enqueued type samples"
  task :process do
    TypeFusion.processor.process!
  end
end
