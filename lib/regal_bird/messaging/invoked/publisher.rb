# frozen_string_literal: true

require "regal_bird/messaging/invoked/retry_queue_config"
require "regal_bird/messaging/queue"
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
          backoff_queue(next_ttl(message))
          retry_exchange.publish(
            EventSerializer.serialize(message.event),
            routing_key: message.routing_key,
            headers: message.headers.merge(
              "retry-wait" => next_ttl(message),
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

        def backoff_queue(ttl)
          config = rq_config(ttl)
          q = work_exchange.channel.queue(
            config.name,
            config.channel_opts(work_exchange)
          ).bind(retry_exchange, config.bind_opts)
          Messaging::Queue.new(q, config.route)
        end

        def rq_config(ttl)
          RetryQueueConfig.new(ttl)
        end

        attr_reader :work_exchange, :retry_exchange

      end

    end
  end
end
