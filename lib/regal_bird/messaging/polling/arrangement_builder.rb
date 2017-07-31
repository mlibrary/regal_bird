require "regal_bird/messaging/polling/arrangement"
require "regal_bird/messaging/polling/publisher"
require "regal_bird/messaging/polling/work_queue_config"
require "regal_bird/messaging/polling/retry_queue_config"
require "regal_bird/messaging/queue"
require "regal_bird/event"
require "regal_bird/messaging/message"

module RegalBird
  module Messaging
    module Polling

      class ArrangementBuilder
        def initialize(step_class, interval)
          @step_class = step_class
          @interval = interval
        end

        def build(wx, rx)
          wq = Messaging::Queue.new(backend_wq(wx), wq_config.route)
          rq = Messaging::Queue.new(backend_rq(wx,rx), rq_config.route)
          publisher = Publisher.new(wx,rx)
          arrangement = Arrangement.new(wq, rq, publisher)
          arrangement.set_consumer(step_class)
          publisher.retry(initial_message)
          arrangement
        end

        private

        def initial_message
          Message.new(
            wq_config.route,
            { headers: rq_config.route },
            RegalBird::Event.new(
              item_id: step_class.to_s,
              emitter: step_class,
              state: :source,
              data: {},
              start_time: Time.at(0),
              end_time: Time.at(0)
            )
          )
        end

        def backend_wq(wx)
          wx.channel.queue(wq_config.name, wq_config.channel_opts(nil))
            .bind(wx, wq_config.bind_opts)
        end

        def backend_rq(wx, rx)
          rx.channel.queue(rq_config.name, rq_config.channel_opts(wx))
            .bind(rx, rq_config.bind_opts)
        end

        def wq_config
          WorkQueueConfig.new(step_class, "source.#{step_class}")
        end

        def rq_config
          RetryQueueConfig.new(step_class, interval)
        end

        attr_reader :step_class, :interval

      end

    end
  end
end