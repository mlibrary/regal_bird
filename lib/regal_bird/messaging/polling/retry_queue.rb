module RegalBird
  module Messaging
    module Polling

      class RetryQueue

        def initialize(channel, work_exchange, retry_exchange, step_class, interval)
          @step_class = step_class
          @queue = channel.queue(
            name,
            exclusive: false,
            auto_delete: false,
            durable: true,
            arguments: {
              "x-dead-letter-exchange" => work_exchange.name,
              "x-message-ttl" => interval * 1000,
              "x-max-length" => 1
            }
          )
          @queue.bind(retry_exchange,
            arguments: binding.merge({"x-match" => "all"})
          )
        end

        def binding
          { "source" => step_class.to_s }
        end

        private
        attr_reader :step_class

        def name
          "source-#{step_class.to_s.downcase.gsub("::", "_")}-retry"
        end

      end

    end
  end
end
