module RegalBird
  module Messaging
    module Logging

      class Consumer

        # @param queue [Queue]
        # @param logger [Logger]
        def initialize(queue, logger)
          @queue = queue
          @logger = logger

          queue.subscribe(
            consumer_tag: "#{queue.name}-#{queue.consumer_count + 1}",
            manual_ack: true,
            exclusive: false,
            block: false
          ) do |delivery_info, properties, payload|
            perform(Message.new(delivery_info, properties, EventSerializer.deserialize(payload)))
          end
        end

        # @param message [Message]
        def perform(message)
          logger.info message_to_h(message)
          queue.ack(message.delivery_tag)
        end

        attr_reader :queue, :logger

        private

        def message_to_h(message)
          {
            routing_key: message.routing_key,
            headers: message.headers,
            item_id: message.event.item_id,
            emitter: message.event.emitter,
            state: message.event.state,
            start_time: message.event.start_time,
            end_time: message.event.end_time,
            data: message.event.data
          }
        end
      end

    end
  end
end

