# frozen_string_literal: true


module RegalBird
  module Messaging
    module Invoked

      class WorkQueueConfig
        # Routing object replaces params easily

        def initialize(step_class, routing_key)
          @step_class = step_class
          @routing_key = routing_key
        end

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
          "action-#{step_class.to_s.downcase.gsub("::", "_")}-work"
        end

        def route
          { routing_key: routing_key }
        end

        private
        attr_reader :step_class, :routing_key
      end

    end
  end
end
