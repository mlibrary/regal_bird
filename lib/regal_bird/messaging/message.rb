# frozen_string_literal: true

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
        delivery_info[:delivery_tag] || "not_yet_delivered"
      end

      def headers
        properties[:headers] || {}
      end

      def routing_key
        delivery_info[:routing_key] || "unrouted"
      end

      def eql?(other)
        delivery_tag == other.delivery_tag &&
          headers == other.headers &&
          routing_key == other.routing_key &&
          event == other.event
      end
      alias_method :==, :eql?

      private

      attr_reader :delivery_info, :properties

    end

  end
end
