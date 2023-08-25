# frozen_string_literal: true

module TypeFusion
  class SampleJob
    include Litejob

    queue_as :default

    def perform(sample)
      body = { sample: JSON.parse(sample) }.to_json

      TypeFusion::Client.instance.post(body)
    rescue StandardError => e
      puts e.inspect
    end
  end
end
