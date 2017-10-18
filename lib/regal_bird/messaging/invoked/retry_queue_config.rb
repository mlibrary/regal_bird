# frozen_string_literal: true


module RegalBird
  module Messaging
    module Invoked

      class RetryQueueConfig

        def initialize(ttl)
          @ttl = ttl
        end

        def channel_opts(work_exchange)
          {
            exclusive:   false,
            auto_delete: true,
            durable:     false,
            arguments:   {
              "x-dead-letter-exchange" => work_exchange.name,
              "x-message-ttl"          => ttl.to_i,
              "x-expires"              => ttl.expiration.to_i
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
          { "retry-wait" => ttl.to_i }
        end

        def init_messages
          []
        end

        private

        attr_reader :ttl
      end

    end
  end
end
