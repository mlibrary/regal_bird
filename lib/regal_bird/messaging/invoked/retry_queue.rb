module RegalBird
  module Messaging
    module Invoked

      class RetryQueue

        def initialize(channel, work_exchange, retry_exchange, ttl)
          @ttl = ttl
          @queue = channel.queue(
            name,
            exclusive: false,
            auto_delete: true,
            durable: false,
            arguments: {
              "x-dead-letter-exchange" => work_exchange.name,
              "x-message-ttl" => ttl * 1000,
              "x-expires" => ttl * 2 * 1000
            }
          )
          @queue.bind(retry_exchange, arguments: binding.merge({ "x-match" => "all" }))
        end

        def binding
          { "retry-wait" => ttl }
        end

        private
        attr_reader :ttl

        def name
          "action-retry-#{ttl}"
        end

      end

    end
  end
end
