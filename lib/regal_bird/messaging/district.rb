module RegalBird
  module Messaging

    class District

      attr_reader :name

      def initialize(name, catalog_tag, letter_tag)
        @name = name
        @address_book = AddressBook.new(catalog_tag, letter_tag)
      end

      def address_for(recipient)
        address_book.regular(recipient) # todo: rename
      end

      def add_catalog(catalog)
        catalogs << catalog
      end

      def add_letter(letter)
        letters << letter
      end

      private
      attr_reader :address_book

      def catalogs
        @catalogs ||= []
      end

      def letters
        @letters ||= []
      end

    end

  end
end