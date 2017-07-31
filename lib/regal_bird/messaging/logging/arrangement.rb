# frozen_string_literal: true

require "regal_bird/messaging/logging/consumer"

module RegalBird
  module Messaging
    module Logging

      class Arrangement

        def initialize(work_queue)
          @work_queue = work_queue
          @consumer = nil
        end

        def set_consumer(logger)
          self.consumer = Consumer.new(work_queue, logger)
        end

        def delete
          work_queue.delete
        end

        private
        attr_reader :work_queue
        attr_accessor :consumer

      end

    end
  end
end
