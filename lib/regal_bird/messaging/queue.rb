# frozen_string_literal: true

module RegalBird
  module Messaging

    class Queue < SimpleDelegator

      attr_reader :route

      def initialize(queue, route)
        @queue = queue
        @route = route
        __setobj__ @queue
      end

      def ack(delivery_tag)
        channel.ack(delivery_tag, false)
      end

    end

  end
end
