# frozen_string_literal: true


module RegalBird
  module Messaging
    module Logging

      class WorkQueueConfig

        def channel_opts(_)
          {
            exclusive:   false,
            auto_delete: false,
            durable:     true
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
          { routing_key: "#" }
        end
      end

    end
  end
end
