# frozen_string_literal: true

require "regal_bird/messaging/event_serializer"

module RegalBird
  module Messaging
    module Polling

      class Exchange
        def initialize(backend_exchange)
          @exchange = backend_exchange
        end

        def retry(message)
          exchange.retry.publish(
            EventSerializer.serialize(message.event),
            routing_key: message.routing_key,
            headers: message.headers
          )
        end

        def publish(event)
          exchange.work.publish(
            EventSerializer.serialize(event),
            routing_key: "action.#{event.state}"
          )
        end

        private
        attr_reader :exchange
      end

    end
  end
end
