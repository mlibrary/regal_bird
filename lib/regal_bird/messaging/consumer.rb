# frozen_string_literal: true

module RegalBird
  module Messaging

    class Consumer
      def initialize(step_class, address_book, dropbox)
        @step_class = step_class
        @address_book = address_book
        @dropbox = dropbox
      end

      def perform(mail)
        mail.open do |event|
          [step_class.new(event).execute].flatten.each do |new_event|
            dropbox.drop(OutgoingMail.new(address_book.regular(new_event.state), new_event))
          end
        end
      end

      private
      attr_reader :step_class, :address_book, :dropbox

    end

  end
end
