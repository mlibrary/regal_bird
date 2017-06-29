require "securerandom"
require "regal_bird/event"

module RegalBird

  # Actions are executed against an item based on the action's
  # associated state in the plan. They receive and emit an
  # Event.
  class Action

    attr_reader :event

    # @param event [Event]
    def initialize(event)
      @event = event
    end

    # @return [Event]
    def execute
      raise NotImplementedError
    end

    def success(state, data)
      {state: state, data: data}
    end

    def noop
      {state: event.state, data: {}}
    end

    def failure(message)
      {state: event.state, data: {error: message}}
    end

    def wrap_execution
      start_time = Time.now.utc
      begin
        result = yield
        RegalBird::Event.new(item_id: event.item_id, state: result[:state],
          emitter: self.class.to_s, start_time: start_time, end_time: Time.now.utc,
          data: event.data.merge(result[:data])
        )
      rescue StandardError => e
        RegalBird::Event.new(item_id: event.item_id, state: event_log.state,
          emitter: self.class.to_s, start_time: start_time, end_time: Time.now.utc,
          data: {error: "#{e.message}\n#{e.backtrace}"}
        )
      end
    end

  end

  class Action::Clean < Action
    def execute; end
  end

end
