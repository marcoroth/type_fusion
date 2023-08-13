# frozen_string_literal: true

module TypeFusion
  class SampleJob
    include Litejob

    queue_as :default

    def perform(sample)
      puts sample.inspect
    end
  end
end
