require "regal_bird/messaging/queue"

module RegalBird
  module Messaging
    module Logging

      class WorkQueue < Queue

        def initialize(channel, work_exchange)
          @channel = channel
          @work_exchange = work_exchange
          super(channel, work_exchange)
        end

        def channel_opts
          {
            exclusive: false,
            auto_delete: false,
            durable: true
          }
        end

        def bind_opts
          route
        end

        def name
          "logger-work"
        end

        # The route, which matches all routing keys.
        def route
          {routing_key: "#" }
        end
      end

    end
  end
end
