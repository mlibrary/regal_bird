# frozen_string_literal: true

require "regal_bird/messaging/channel"
require "regal_bird/messaging/event_serializer"
require "regal_bird/messaging/exchange"
require "regal_bird/messaging/exchange_builder"
require "regal_bird/messaging/message"
require "regal_bird/messaging/queue"
require "regal_bird/messaging/invoked"
require "regal_bird/messaging/polling"
require "regal_bird/messaging/logging"

module RegalBird
  module Messaging

    class << self
      def work_exchange_name(plan)
        "#{plan.name}-work"
      end

      def retry_exchange_name(plan)
        "#{plan.name}-retry"
      end

      def work_queue_route(step_class)
        "source.#{step_class}"
      end

      def retry_queue_route(step_class)
        { "source" => step_class.to_s }
      end

    end

  end
end
