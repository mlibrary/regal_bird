module RegalBird
  module Messaging

      class Message
        def initialize(delivery_info, properties, event)
          @delivery_info = delivery_info
          @properties = properties
          @event = event
        end

        attr_reader :event

        def delivery_tag
          delivery_info.delivery_tag
        end

        def headers
          properties.headers || {}
        end

        def routing_key
          delivery_info.routing_key
        end


        private
        attr_reader :delivery_info, :properties

      end

  end
end
