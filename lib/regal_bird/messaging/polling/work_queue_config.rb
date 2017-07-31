# frozen_string_literal: true


module RegalBird
  module Messaging
    module Polling

      class WorkQueueConfig

        def initialize(step_class, routing_key)
          @step_class = step_class
          @routing_key = routing_key
        end

        def channel_opts(_)
          {
            exclusive:   false,
            auto_delete: false,
            durable:     true,
            arguments:   {
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
          { routing_key: routing_key }
        end

        def init_messages
          []
        end

        private
        attr_reader :step_class, :routing_key
      end

    end
  end
end
