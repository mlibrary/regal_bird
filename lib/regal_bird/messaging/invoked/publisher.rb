# frozen_string_literal: true

require "regal_bird/messaging/invoked/retry_queue"
require "regal_bird/messaging/event_serializer"

module RegalBird
  module Messaging
    module Invoked

      class Publisher

        def initialize(work_exchange, retry_exchange)
          @work_exchange = work_exchange
          @retry_exchange = retry_exchange
        end

        def retry(message, error_msg)
          new_ttl = next_ttl(message)
          create_backoff_queue!(new_ttl)
          retry_exchange.publish(
            EventSerializer.serialize(message.event),
            routing_key: message.routing_key,
            headers: message.headers.merge("retry-wait" => new_ttl,
              "error" => error_msg)
          )
        end

        def success(event)
          work_exchange.publish(
            EventSerializer.serialize(event),
            routing_key: "action.#{event.state}"
          )
        end

        private

        def next_ttl(message)
          message.headers.fetch("retry-wait", 1) * 2
        end

        def create_backoff_queue!(ttl)
          RetryQueue.new(
            work_exchange.channel,
            work_exchange,
            retry_exchange,
            ttl
          )
        end

        attr_reader :work_exchange, :retry_exchange

      end

    end
  end
end
