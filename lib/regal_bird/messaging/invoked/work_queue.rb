module RegalBird
  module Messaging
    module Invoked

      class WorkQueue

        def initialize(channel, work_exchange, step_class, routing_key)
          @step_class = step_class
          @queue = channel.queue(
            name,
            exclusive: false,
            auto_delete: false,
            durable: true
          )
          @queue.bind(work_exchange, routing_key: routing_key)
        end

        def ack(delivery_tag)
          @queue.ack(delivery_tag, false)
        end

        private
        attr_reader :step_class

        def name
          "action-#{step_class.to_s.downcase.gsub("::", "_")}-work"
        end

      end

    end
  end
end
