require "regal_bird/messaging/invoked/arrangement"
require "regal_bird/messaging/invoked/publisher"
require "regal_bird/messaging/invoked/work_queue_config"
require "regal_bird/messaging/queue"

module RegalBird
  module Messaging
    module Invoked

      class ArrangementBuilder
        def initialize(step_class, state, num_workers)
          @step_class = step_class
          @state = state
          @num_workers = num_workers
        end

        def build(wx, rx)
          wq = Messaging::Queue.new(backend_wq(wx), wq_config.route)
          publisher = Publisher.new(wx,rx)
          arrangement = Arrangement.new(wq, publisher)
          num_workers.times { arrangement.add(step_class) }
          arrangement
        end

        private

        def backend_wq(wx)
          wx.channel.queue(wq_config.name, wq_config.channel_opts(nil))
            .bind(wx, wq_config.bind_opts)
        end

        def wq_config
          WorkQueueConfig.new(step_class, "action.#{state}")
        end

        attr_reader :step_class, :state, :num_workers

      end

    end
  end
end