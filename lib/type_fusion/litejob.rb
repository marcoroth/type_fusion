# frozen_string_literal: true

require "litejob"

# Litequeue.configure do |config|
#   config.path = "db/type_fusion/queue.sqlite3"
# end

Litejob.configure do |config|
  config.logger = Class.new do
    def self.info(*args)
    end
  end
end
