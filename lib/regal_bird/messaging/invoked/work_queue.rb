module RegalBird
  module Messaging
    module Invoked

      class WorkQueue

        def initialize(channel, work_exchange, step_class, routing_key)
          @channel = channel
          @step_class = step_class
          @routing_key = routing_key
          @queue = channel.queue(
            name,
            exclusive: false,
            auto_delete: false,
            durable: true
          )
          @queue.bind(work_exchange, routing_key: routing_key)
        end

        def ack(delivery_tag)
          @channel.ack(delivery_tag, false)
        end

        def route
          {routing_key: routing_key}
        end

        def name
          "action-#{step_class.to_s.downcase.gsub("::", "_")}-work"
        end

        private
        attr_reader :step_class, :routing_key

      end

    end
  end
end
