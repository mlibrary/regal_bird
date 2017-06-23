module RegalBird
  module Messaging
    module Invoked

      class Arrangement
        def initialize(channel, work_exchange, retry_exchange, step_class, state, num_workers)
          publisher = Publisher.new(work_exchange, retry_exchange)
          work_queue = WorkQueue.new(channel, work_exchange, step_class, "action.#{state}")
          num_workers.times do
            Consumer.new(work_queue, publisher, step_class)
          end
        end
      end

    end
  end
end
