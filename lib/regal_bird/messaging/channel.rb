# frozen_string_literal: true

require "bunny"
require "regal_bird/messaging/exchange"

module RegalBird
  module Messaging

    class Channel < SimpleDelegator

      def initialize
        @channel = connection.create_channel
        @channel.prefetch(1)
        __setobj__(@channel)
      end

      def work_exchange(name)
        Exchange.new(self.topic("#{name}-work", durable: true, auto_delete: false))
      end

      def retry_exchange(name)
        Exchange.new(self.headers("#{name}-retry", durable: true, auto_delete: false))
      end

      private

      def connection
        unless @connection
          @connection = Bunny.new
          @connection.start
        end
        @connection
      end
    end

  end
end
