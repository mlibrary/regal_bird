# frozen_string_literal: true

require "regal_bird/messaging/event_serializer"
require "regal_bird/messaging/message"

module RegalBird
  module Messaging
    module Invoked

      class Consumer

        # @param queue [Queue]
        # @param publisher [Publisher]
        # @param step_class [Class] E.g. some_action.class
        def initialize(queue, publisher, step_class)
          @queue = queue
          @publisher = publisher
          @step_class = step_class
          subscribe!(queue)
        end

        # @param message [Message]
        def perform(message)
          result = step_class.new(message.event).safe_execute
          publisher.success(result)
        rescue StandardError => e
          publisher.retry(message, "#{e.message}\n#{e.backtrace}")
        ensure
          queue.ack(message.delivery_tag)
        end

        attr_reader :queue, :publisher, :step_class

        private

        def subscribe!(queue)
          queue.subscribe(
            consumer_tag: "#{queue.name}-#{queue.consumer_count + 1}",
            manual_ack: true,
            exclusive: false,
            block: false
          ) do |delivery_info, properties, payload|
            perform(Message.new(delivery_info, properties, EventSerializer.deserialize(payload)))
          end
        end

      end

    end
  end
end
