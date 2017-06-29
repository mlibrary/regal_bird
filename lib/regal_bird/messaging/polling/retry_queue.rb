# frozen_string_literal: true

require "regal_bird/messaging/queue"

module RegalBird
  module Messaging
    module Polling

      class RetryQueue < Queue

        def initialize(channel, work_exchange, retry_exchange, step_class, interval)
          @channel = channel
          @work_exchange = work_exchange
          @retry_exchange = retry_exchange
          @step_class = step_class
          @interval = interval
          super(channel, retry_exchange)
        end

        def channel_opts
          {
            exclusive:   false,
            auto_delete: false,
            durable:     true,
            arguments:   {
              "x-dead-letter-exchange" => work_exchange.name,
              "x-message-ttl"          => interval * 1000,
              "x-max-length"           => 1
            }
          }
        end

        def bind_opts
          { arguments: route.merge("x-match" => "all") }
        end

        def name
          "source-#{step_class.to_s.downcase.gsub("::", "_")}-retry"
        end

        def route
          { "source" => step_class.to_s }
        end

        private

        attr_reader :work_exchange, :step_class, :interval
      end

    end
  end
end
