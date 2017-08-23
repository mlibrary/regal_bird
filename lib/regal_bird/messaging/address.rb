module RegalBird
  module Messaging


    class Address

      def initialize(type, routing_key, headers)
        @type = type
        @routing_key = routing_key
        @headers = headers
      end

      def return?
        RETURN_TYPES.include?(type)
      end

      def letter?
        LETTER_TYPES.include?(type)
      end

      def catalog?
        CATALOG_TYPES.include?(type)
      end

      attr_reader :routing_key, :headers

      private

      attr_reader :type

      LETTER_TYPES = [:letter, :letter_return]
      CATALOG_TYPES = [:catalog, :catalog_return]
      RETURN_TYPES = [:letter_return, :catalog_return]

    end

  end
end