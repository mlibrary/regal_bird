# frozen_string_literal: true

require "regal_bird/messaging/event_serializer"

module RegalBird
  module Messaging
    module Polling

      class Publisher
        def initialize(retry_exchange)
          @retry_exchange = retry_exchange
        end

        def retry(message)
          retry_exchange.publish(
            EventSerializer.serialize(message.event),
            routing_key: message.routing_key,
            headers: message.headers
          )
        end

        private
        attr_reader :retry_exchange
      end

    end
  end
end
