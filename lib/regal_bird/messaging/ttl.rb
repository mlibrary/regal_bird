module RegalBird
  module Messaging

    class TTL
      def initialize(milliseconds = 1000)
        @milliseconds = milliseconds.to_i
      end

      def successor
        TTL.new(milliseconds * 2)
      end

      def expiration
        TTL.new(milliseconds * 2)
      end

      def to_s
        milliseconds.to_s
      end

      def to_i
        milliseconds
      end

      private
      attr_reader :milliseconds
    end

  end
end
