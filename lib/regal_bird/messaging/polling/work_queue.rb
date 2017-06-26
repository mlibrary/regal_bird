module RegalBird
  module Messaging
    module Polling

      class WorkQueue < SimpleDelegator

        def initialize(channel, work_exchange, step_class, routing_key)
          @channel = channel
          @step_class = step_class
          @routing_key = routing_key
          @queue = channel.queue(
            name,
            exclusive: false,
            auto_delete: false,
            durable: true,
            arguments: {
              "x-max-length" => 1
            }
          )
          @queue.bind(work_exchange, routing_key: routing_key)
          __setobj__ @queue
        end

        def ack(delivery_tag)
          @channel.ack(delivery_tag, false)
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
