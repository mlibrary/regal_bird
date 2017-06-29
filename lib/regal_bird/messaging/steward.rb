# frozen_string_literal: true

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
        self.sources = plan.sources.map do |source_declaration|
          create_source(source_declaration)
        end
        self.actions = plan.actions.map do |action_declaration|
          create_action(action_declaration)
        end
        self.log = Logging::Arrangement.new(channel, work_exchange, plan.logger)
        self.user_event_publisher = Invoked::Publisher.new(work_exchange, nil)
      end

      def emit(event)
        user_event_publisher.success(event)
      end

      def delete
        sources.each(&:delete)
        actions.each(&:delete)
        retry_exchange.delete
        work_exchange.delete
      end

      private

      def create_source(decl)
        Polling::Arrangement.new(
          channel, work_exchange, retry_exchange,
          decl.klass, decl.interval
        )
      end

      def create_action(decl)
        Invoked::Arrangement.new(
          channel, work_exchange, retry_exchange,
          decl.klass, decl.state,
          decl.num_workers
        )
      end

      def
      def(_retry_exchange)
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
