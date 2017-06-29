# frozen_string_literal: true

require "regal_bird/messaging/event_serializer"

module RegalBird
  module Messaging
    module Polling

      class Publisher

        def initialize(work_exchange, retry_exchange)
          @work_exchange = work_exchange
          @retry_exchange = retry_exchange
        end

        def retry(message)
          retry_exchange.publish(
            EventSerializer.serialize(message.event),
            routing_key: message.routing_key,
            headers: message.headers
          )
        end

        def success(event)
          work_exchange.publish(
            EventSerializer.serialize(event),
            routing_key: "action.#{event.state}"
          )
        end

        private

        attr_reader :work_exchange, :retry_exchange

      end

    end
  end
end
