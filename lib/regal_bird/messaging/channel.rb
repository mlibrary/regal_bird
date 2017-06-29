# frozen_string_literal: true

require "bunny"

module RegalBird
  module Messaging

    class Channel < SimpleDelegator
      def initialize
        @channel = connection.create_channel
        @channel.prefetch(1)
        __setobj__(@channel)
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
