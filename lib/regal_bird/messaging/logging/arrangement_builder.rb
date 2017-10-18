require "regal_bird/messaging/logging/arrangement"
require "regal_bird/messaging/logging/work_queue_config"
require "regal_bird/messaging/queue"

module RegalBird
  module Messaging
    module Logging

      class ArrangementBuilder
        def initialize(logger)
          @logger = logger
        end

        def build(wx, _)
          wq = Messaging::Queue.new(backend_wq(wx), wq_config.route)
          arrangement = Arrangement.new(wq)
          arrangement.set_consumer(logger)
          arrangement
        end

        private

        def backend_wq(wx)
          wx.channel.queue(wq_config.name, wq_config.channel_opts(nil))
            .bind(wx, wq_config.bind_opts)
        end

        def wq_config
          @wq_config ||= WorkQueueConfig.new
        end

        attr_reader :logger

      end

    end
  end
end
