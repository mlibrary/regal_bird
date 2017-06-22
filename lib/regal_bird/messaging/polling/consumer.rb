module RegalBird
  module Messaging
    module Polling

      class Consumer

        # @param queue [Queue]
        # @param publisher [Publisher]
        # @param step_class [Class] E.g. some_step_class.class
        def initialize(queue, publisher, step_class)
          @queue = queue
          @publisher = publisher
          @step_class = step_class

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
          publisher.retry(message)
          queue.ack(message.delivery_tag)
          step_class.new(message.event).execute.each do |event|
            publisher.success(event)
          end
        end

        private
        attr_reader :queue, :publisher, :step_class
      end

    end
  end
end

