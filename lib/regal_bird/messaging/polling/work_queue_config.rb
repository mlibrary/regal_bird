# frozen_string_literal: true


module RegalBird
  module Messaging
    module Polling

      class WorkQueueConfig
        def initialize(routing_info)
          @routing_info = routing_info
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
          routing_info.work_queue_name
        end

        def route
          routing_info.work_queue_route
        end

        private
        attr_reader :routing_info
      end

    end
  end
end

