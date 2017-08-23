# frozen_string_literal: true

module RegalBird
  module Messaging

    class Mailbox

      def initialize(queue)
        @queue = queue
        @consumers = []
      end

      def add_consumer(consumer)
        consumers << consumer
        queue.subscribe(
          consumer_tag: "#{queue.name}-#{queue.consumer_count + 1}",
          manual_ack: true,
          exclusive: false,
          block: false
        ) do |delivery_info, properties, payload|
          consumer.perform(
            # Some sort of incantation to get this to work
            #Message.new(delivery_info, properties, EventSerializer.deserialize(payload))
            Mail.new(_, EventSerializer.deserialize(payload))
          )
        end
      end

      def ack(delivery_tag)
        queue.ack(delivery_tag)
      end

      private
      attr_reader :queue, :consumers

    end

  end
end
