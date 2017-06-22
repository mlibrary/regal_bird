module RegalBird
  module Messaging
    module Invoked

      class Publisher

        def initialize(work_exchange, retry_exchange)
          @work_exchange = work_exchange
          @retry_exchange = retry_exchange
        end

        def retry(message, error_msg)
          new_ttl = message.headers.fetch("retry-wait", 1) * 2
          RetryQueue.new(
            work_exchange.channel,
            work_exchange,
            retry_exchange,
            new_ttl
          )

          retry_exchange.publish(
            EventSerializer.serialize(message.event),
            routing_key: message.routing_key,
            headers: message.headers.merge({
              "retry-wait" => new_ttl,
              "error" => error_msg
            })
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
