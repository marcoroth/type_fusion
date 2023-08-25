# frozen_string_literal: true

module TypeFusion
  class Processor
    def initialize(amount = 4)
      @amount = amount
      @servers = []
      @started = false
    end

    def should_run?
      enqueued_jobs.positive?
    end

    def started?
      @started
    end

    def enqueued_jobs
      Litequeue.instance.count
    end

    def stop!
      @servers.each do |server|
        server.instance_variable_get(:@scheduler).context.kill
      end
      @servers = []
      @started = false
    end

    def start!
      @amount.times do
        @servers << Litejob::Server.new
      end
      @started = true
    end

    def process!
      puts "[TypeFusion] Start processing of #{enqueued_jobs} samples using #{@amount} threads..."

      Signal.trap("INT") do
        puts "\n[TypeFusion] Stop processing of TypeFusion samples..."
        stop!
      end
      
      start!

      while should_run?
        puts "[TypeFusion] Remaining samples: #{Litequeue.instance.count}"
        sleep 1
      end

      puts "[TypeFusion] Finished!"

      puts "[TypeFusion] Congratulations! You just contributed samples to the following gems and helped making the Ruby ecosystem better for the whole community! Thank you!\n"
      puts "- #{gems.join("\n- ")}"

      stop!
    end

    private

    def gems
      TypeFusion::Sampler.instance.samples.map(&:gem_name).uniq.sort
    end
  end
end
