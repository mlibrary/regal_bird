# frozen_string_literal: true

require "regal_bird/event"
require "regal_bird/messaging/message"

module RegalBird
  module Messaging
    module Polling

      class RetryQueueConfig

        def initialize(routing_info)
          @routing_info = routing_info
        end

        def channel_opts(work_exchange)
          {
            exclusive:   false,
            auto_delete: false,
            durable:     true,
            arguments:   {
              "x-dead-letter-exchange" => work_exchange.name,
              "x-message-ttl"          => routing_info.x_message_ttl,
              "x-max-length"           => 1
            }
          }
        end

        def bind_opts
          { arguments: route.merge("x-match" => "all") }
        end

        def queue_name
          routing_info.retry_queue_name
        end

        def route
          routing_info.route
        end

        private
        attr_reader :routing_info
      end

    end
  end
end
