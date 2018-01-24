# frozen_string_literal: true

require "regal_bird/action_result"

module RegalBird

  # Actions are executed against an item based on the action's
  # associated state in the plan. They receive and emit an
  # Event.
  class Action
    class Clean < Action
      def execute(_); end
    end

    # @param event [Event]
    def initialize(event, result_builder = ActionResult)
      @event = event
      @result_builder = result_builder
    end

    attr_reader :event

    # @param result [ActionResult]
    # @return [Event]
    def execute(result)
      raise NotImplementedError
    end

    def safe_execute
      result = result_builder.for(self)
      begin
        execute(result)
      rescue StandardError => e
        RegalBird.config.logger.error "#{e.message}\n#{e.backtrace}"
        result.failure("#{e.message}\n#{e.backtrace}")
      end
    end

    private

    attr_reader :result_builder

  end

end
