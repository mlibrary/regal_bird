require "regal_bird/messaging/queue"

module RegalBird
  module Messaging
    module Polling

      class WorkQueue < Queue

        def initialize(channel, work_exchange, step_class, routing_key)
          @channel = channel
          @step_class = step_class
          @routing_key = routing_key
          super(channel, work_exchange)
        end

        def channel_opts
          {
            exclusive: false,
            auto_delete: false,
            durable: true,
            arguments: {
              "x-max-length" => 1
            }
          }
        end

        def bind_opts
          route
        end

        def name
          "source-#{step_class.to_s.downcase.gsub("::", "_")}-work"
        end

        def route
          {routing_key: routing_key}
        end

        private
        attr_reader :step_class, :routing_key
      end

    end
  end
end