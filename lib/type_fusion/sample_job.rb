# frozen_string_literal: true

require "lhc"

module TypeFusion
  class SampleJob
    include Litejob

    queue_as :default

    def perform(sample)
      LHC.json.post(TypeFusion.config.endpoint, body: { sample: JSON.parse(sample) })
    rescue => e
      puts e.inspect
    end
  end
end
