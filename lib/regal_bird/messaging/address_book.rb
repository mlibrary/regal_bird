module RegalBird
  module Messaging

    # Allows customers to look up addresses
    class AddressBook

      def initialize(catalog_tag, letter_tag)
        @catalog_tag = catalog_tag
        @letter_tag = letter_tag
      end

      # Get a return address for the catalog.
      # @param recipient [String] E.g. for a source, this is the source.class
      # @return [Address]
      def catalog_return(recipient)
        Address.new(
          true,
          "#{catalog_tag}.#{recipient}",
          { catalog_tag => recipient }
        )
      end


      # Get an address for the recipient
      # @param recipient [String] E.g. for an action, this is the state.
      # @return [Address]
      def regular(recipient)
        Address.new(
          false,
          "#{letter_tag}.#{recipient}",
          {})
      end

      # Get a return address for the recipient and other data.
      # @param recipient [String] E.g. for an action, this is the state.
      # @param current_ttl [Fixnum] The old ttl for the message.
      # @param error_msg [String] An error message to include in the
      #   message metadata.
      # @return [Address]
      def regular_return(recipient, current_ttl, error_msg)
        Address.new(
          true,
          "#{letter_tag}.#{recipient}",
          {
            "retry-wait" => current_ttl,
            "error" => error_msg
          }
        )
      end

      private

      attr_reader :catalog_tag, :letter_tag

    end

  end
end