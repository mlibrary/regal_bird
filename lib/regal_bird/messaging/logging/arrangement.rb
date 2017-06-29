# frozen_string_literal: true

require "regal_bird/messaging/logging/work_queue"
require "regal_bird/messaging/logging/consumer"

module RegalBird
  module Messaging
    module Logging

      class Arrangement

        # @param channel [Channel]
        # @param work_exchange [WorkExchange]
        # @param logger [Logger] A logger instance that follows the Logger
        #   interface.
        def initialize(channel, work_exchange, logger)
          @work_queue = WorkQueue.new(channel, work_exchange)
          Consumer.new(@work_queue, logger)
        end

        def delete
          @work_queue.delete
        end

      end

    end
  end
end
