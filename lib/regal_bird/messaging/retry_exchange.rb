module RegalBird
  module Messaging

    class RetryExchange < SimpleDelegator
      def initialize(name, channel)
        @exchange = channel.headers(name,
          durable: true,
          auto_delete: false
        )
        @channel = channel
        __setobj__(@exchange)
      end
    end

  end
end
