module RegalBird
  module Messaging

    class PostalService
      def initialize(channel)
        @channel = channel
      end

      def serve(district)
        offices[district.name] = Office.new(
          Lorry.new(channel.work_exchange("#{district.name}-work")),
          Lorry.new(channel.retry_exchange("#{district.name}-retry"))
        )
        district.catalogs.each do |catalog|
          offices[district.name].serve_catalog(district.catalog_tag, catalog)
        end
        district.letters.each do |letter|
          offices[district.name].serve_letter(district.letter_tag, letter)
        end
      end

      private
      attr_reader :channel

      def offices
        @offices ||= {}
      end

    end

  end
end