# frozen_string_literal: true

require "regal_bird/messaging/queue"

module RegalBird
  module Messaging
    module Invoked

      class RetryQueue < Queue

        def initialize(channel, work_exchange, retry_exchange, ttl)
          @channel = channel
          @work_exchange = work_exchange
          @retry_exchange = retry_exchange
          @ttl = ttl
          super(channel, retry_exchange)
        end

        def channel_opts
          {
            exclusive:   false,
            auto_delete: true,
            durable:     false,
            arguments:   {
              "x-dead-letter-exchange" => work_exchange.name,
              "x-message-ttl"          => ttl * 1000,
              "x-expires"              => ttl * 2 * 1000
            }
          }
        end

        def bind_opts
          { arguments: route.merge("x-match" => "all") }
        end

        def name
          "action-retry-#{ttl}"
        end

        def route
          { "retry-wait" => ttl }
        end

        private

        attr_reader :work_exchange, :ttl
      end

    end
  end
end
