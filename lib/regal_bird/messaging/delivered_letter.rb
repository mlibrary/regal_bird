# frozen_string_literal: true

module RegalBird
  module Messaging

    class DeliveredLetter

      def initialize(address, event, delivery_info)
        @address = address
        @event = event
        @delivery_info = delivery_info
      end

      def open(acker, dropbox)
        begin
          yield event
        rescue StandardError => e
          # if we pass the office instead of the dropbox, this can instruct
          # the office to construct a new mailbox
          dropbox.drop(error_mail(e))  # here we know it's letter_return
        ensure
          acker.ack(delivery_info)
        end
      end

      private
      attr_reader :address, :event, :delivery_info

      def error_mail(error)
        OutgoingMail.new(
          return_address(error),
          event
        )
      end

      def return_address(error)
        Address.new(
          :letter_return,
          address.routing_key,
          {
            "retry-wait" => address.headers.fetch("retry-wait", 1000) * 2,
            "error" => "#{error.message}\n#{error.backtrace}"
          }
        )
      end

    end

  end
end
