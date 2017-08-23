module RegalBird
  module Messaging

    module Name

      def normalize(name)
        name.downcase.gsub("::", "_")
      end

    end

  end
end