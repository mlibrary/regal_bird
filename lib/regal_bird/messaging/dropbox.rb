module RegalBird
  module Messaging

    class Dropbox
      def initialize(office)
        @office = office
      end

      def drop(mail)
        office.drop(mail)
      end

    end

  end
end