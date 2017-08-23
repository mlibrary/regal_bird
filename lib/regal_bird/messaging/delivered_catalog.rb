# frozen_string_literal: true

module RegalBird
  module Messaging

    class DeliveredCatalog

      def initialize(address, event, delivery_info)
        @address = address
        @event = event
        @delivery_info = delivery_info
      end

      def open(acker, dropbox)
        dropbox.drop(OutgoingMail.new(return_address, event)) # we know it's catalog return
        acker.ack(delivery_info)
        yield event
      end

      private
      attr_reader :address, :event, :delivery_info

      def return_address
        address
      end

    end

  end
end
