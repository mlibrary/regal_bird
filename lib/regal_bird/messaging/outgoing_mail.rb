# frozen_string_literal: true

module RegalBird
  module Messaging

    class OutgoingMail

      attr_reader :address, :payload


      def initialize(address, payload)
        @address = address
        @payload = payload
      end

    end

  end
end
