# frozen_string_literal: true

require "regal_bird/event"
require "regal_bird/messaging/message"

module RegalBird
  module Messaging
    module Polling

      class RetryQueueConfig

        def initialize(step_class, interval)
          @step_class = step_class
          @interval = interval
        end

        def channel_opts(work_exchange)
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

        def queue_name
          "source-#{step_class.to_s.downcase.gsub("::", "_")}-retry"
        end

        def route
          { "source" => step_class.to_s }
        end

        def init_messages
          [Message.new(
            {},
            { headers: route },
            RegalBird::Event.new(
              item_id: step_class.to_s,
              emitter: step_class,
              state: :source,
              data: {},
              start_time: Time.at(0),
              end_time: Time.at(0)
            )
          )]
        end

        private
        attr_reader :step_class, :interval
      end

    end
  end
end
