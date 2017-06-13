module RegalBird
  module Messaging

    class WorkExchange < SimpleDelegator
      def initialize(name, channel)
        @exchange = channel.topic(name,
          durable: true,
          auto_delete: false
        )
        @channel = channel
        __setobj__(@exchange)
      end
    end

  end
end
