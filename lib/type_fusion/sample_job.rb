# frozen_string_literal: true

require "litestack"

module TypeFusion
  class SampleJob
    include Litejob

    self.queue = :default

    def perform(sample)
      puts sample.inspect
    end
  end
end
