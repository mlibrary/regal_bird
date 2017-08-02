# frozen_string_literal: true

require "regal_bird/messaging/polling/arrangement"
require "regal_bird/messaging/polling/arrangement_builder"
require "regal_bird/messaging/polling/consumer"
require "regal_bird/messaging/polling/publisher"
require "regal_bird/messaging/polling/retry_queue_config"
require "regal_bird/messaging/polling/work_queue_config"


module RegalBird
  module Messaging

    module Polling
      class << self
        def work_queue_name(step_class)
          "action-#{step_class.to_s.downcase.gsub("::", "_")}-work"
        end

        def retry_queue_name(step_class)
          "action-#{step_class.to_s.downcase.gsub("::", "_")}-retry"
        end
      end

    end

  end
end
