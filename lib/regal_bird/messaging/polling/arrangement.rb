require "regal_bird/event"
require "regal_bird/messaging/message"
require "regal_bird/messaging/polling/consumer"
require "regal_bird/messaging/polling/publisher"
require "regal_bird/messaging/polling/retry_queue"
require "regal_bird/messaging/polling/work_queue"

module RegalBird
  module Messaging
    module Polling

      class Arrangement

        # @param channel [Channel]
        # @param work_exchange [WorkExchange]
        # @param retry_exchange [RetryExchange]
        # @param step_class [Step]
        # @param interval [Fixnum] seconds
        def initialize(channel, work_exchange, retry_exchange, step_class, interval)
          @step_class = step_class
          @retry_queue = RetryQueue.new(channel, work_exchange, retry_exchange, step_class, interval)
          @work_queue = WorkQueue.new(channel, work_exchange, step_class, "source.#{step_class}")
          @publisher = Publisher.new(work_exchange, retry_exchange)
          @consumer = Consumer.new(@work_queue, @publisher, step_class)
          @publisher.retry(initial_message)
        end

        def delete
          @work_queue.delete
          @retry_queue.delete
        end

        private

        def initial_message
          Message.new(
            @work_queue.route,
            { headers: @retry_queue.route },
            RegalBird::Event.new(
              item_id: @step_class.to_s,
              emitter: @step_class,
              state: :source,
              data: {},
              start_time: Time.at(0),
              end_time: Time.at(0)
            )
          )
        end
      end

    end
  end
end
