# frozen_string_literal: true

module RegalBird
  module Messaging

    class Queue < SimpleDelegator

      def initialize(queue)
        @queue = queue
        __setobj__ @queue
      end

      def ack(delivery_tag)
        channel.ack(delivery_tag, false)
      end

    end

  end
end
z