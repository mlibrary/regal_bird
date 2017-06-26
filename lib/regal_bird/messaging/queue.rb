module RegalBird
  module Messaging

    class Queue < SimpleDelegator
      def initialize(channel, exchange)
        @channel = channel
        @queue = channel.queue(name, channel_opts)
        @queue.bind(exchange, bind_opts)
        __setobj__ @queue
      end

      def ack(delivery_tag)
        channel.ack(delivery_tag, false)
      end

      def name
        raise NotImplementedError
      end

      def channel_opts
        raise NotImplementedError
      end

      def bind_opts
        raise NotImplementedError
      end

      private
      attr_reader :channel, :queue
    end

  end
end
