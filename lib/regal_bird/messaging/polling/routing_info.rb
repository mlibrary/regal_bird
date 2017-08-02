module RegalBird
  module Messaging
    module Polling

      class RoutingInfo
        def initialize(step_class, interval)
          @step_class = step_class
          @interval = interval
        end

        def work_queue_route
          "source.#{step_class}"
        end

        def retry_queue_route
          { "source" => step_class.to_s }
        end

        def work_queue_name
          "source-#{step_class.to_s.downcase.gsub("::", "_")}-work"
        end

        def retry_queue_name
          "source-#{step_class.to_s.downcase.gsub("::", "_")}-retry"
        end

        def x_message_ttl
          interval * 1000
        end

        private
        attr_reader :step_class, :interval
      end

    end
  end
end