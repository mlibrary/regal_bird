module RegalBird
  module Messaging

    class Lorry
      def initialize(excahnge)
        @exchange = exchange
      end

      def name
        exchange.name
      end

      def serve(destination)
        
      end

      def mail(outgoing_mail)

      end

      private

      attr_reader :exchange
    end

  end
end