
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

    end

  end
end
