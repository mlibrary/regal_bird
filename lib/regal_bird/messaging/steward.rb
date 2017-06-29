require "regal_bird/messaging/retry_exchange"
require "regal_bird/messaging/work_exchange"
require "regal_bird/messaging/invoked/arrangement"
require "regal_bird/messaging/logging/arrangement"
require "regal_bird/messaging/polling/arrangement"

module RegalBird
  module Messaging

    # Stewards create the messaging infrastructure for a plan.
    class Steward

      # @param plan [Plan]
      # @param channel [Channel]
      def initialize(channel, plan)
        @channel = channel
        @plan = plan
        @sources = []
        @actions = []
        @log = nil
        @user_event_publisher = nil
      end

      # Create the exchanges, queues, and consumers as described
      # by the plan.
      def create_infrastructure!
        plan.sources.each do |source_declaration|
          sources << Polling::Arrangement.new(
            channel, work_exchange, retry_exchange,
            source_declaration.klass, source_declaration.interval
          )
        end
        plan.actions.each do |action_declaration|
          actions << Invoked::Arrangement.new(
            channel, work_exchange, retry_exchange,
            action_declaration.klass, action_declaration.state,
            action_declaration.num_workers
          )
        end
        log = Logging::Arrangement.new(channel, work_exchange, plan.logger)
        user_event_publisher = Invoked::Publisher.new(work_exchange, nil)
      end

      def emit(event)
        user_event_publisher.success(event)
      end

      def delete
        sources.each {|s| s.delete }
        actions.each {|a| a.delete }
        retry_exchange.delete
        work_exchange.delete
      end

      private

      def retry_exchange
        @retry_exchange ||= RetryExchange.new("#{plan.name}-retry", channel)
      end

      def work_exchange
        @work_exchange ||= WorkExchange.new("#{plan.name}-work", channel)
      end

      attr_reader :channel, :plan
      attr_accessor :actions, :log, :sources, :user_event_publisher
    end

  end
end
