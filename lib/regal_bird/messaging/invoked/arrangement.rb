# frozen_string_literal: true

require "regal_bird/messaging/invoked/consumer"

module RegalBird
  module Messaging
    module Invoked

      class Arrangement
        def initialize(work_queue, publisher)
          @work_queue = work_queue
          @publisher = publisher
          @consumers = []
        end

        def delete
          work_queue.delete
        end

        def add(step_class)
          consumers << Consumer.new(work_queue, publisher, step_class)
        end

        private
        attr_reader :work_queue, :publisher, :consumers

      end

    end
  end
end
