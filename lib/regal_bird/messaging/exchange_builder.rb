require "regal_bird/messaging/exchange"

module RegalBird
  module Messaging

    class ExchangeBuilder

      attr_reader :name

      def initialize(name)
        @name = name
        @arrangement_builders = []
      end

      def add(arrangement_builder)
        arrangement_builders << arrangement_builder
        self
      end


      def build(channel)
        work_exchange = build_work_exchange(channel)
        retry_exchange = build_retry_exchange(channel)
        arrangements = arrangement_builders.map do |builder|
          builder.build(work_exchange, retry_exchange)
        end
        Exchange.new(work_exchange, retry_exchange, arrangements)
      end

      private

      attr_reader :arrangement_builders

      def build_work_exchange(channel)
        channel.topic("#{name}-work", durable: true, auto_delete: false)
      end

      def build_retry_exchange(channel)
        channel.headers("#{name}-retry", durable: true, auto_delete: false)
      end

    end

  end
end