# frozen_string_literal: true

require "regal_bird/messaging/polling/consumer"

module RegalBird
  module Messaging
    module Polling

      class Arrangement

        def initialize(work_queue, retry_queue, publisher)
          @work_queue = work_queue
          @retry_queue = retry_queue
          @publisher = publisher
          @consumer = nil
        end

        def set_consumer(step_class)
          self.consumer = Consumer.new(work_queue, publisher, step_class)
        end

        def delete
          work_queue.delete
          retry_queue.delete
        end

        private

        attr_reader :work_queue, :retry_queue, :publisher
        attr_accessor :consumer

      end

    end
  end
end
