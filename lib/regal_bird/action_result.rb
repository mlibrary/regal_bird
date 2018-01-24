require "regal_bird/event"

module RegalBird
  class ActionResult
    def self.for(action)
      new(action.class, action.event)
    end

    def initialize(emitter, prev_event)
      @emitter = emitter.to_s
      @prev_event = prev_event
      @start_time = Time.now.utc
    end

    def success(state, data)
      RegalBird::Event.new(
        item_id: prev_event.item_id,
        state: state,
        emitter: emitter,
        start_time: start_time,
        end_time: Time.now.utc,
        data: prev_event.data.merge(data)
      )
    end

    def noop
      RegalBird::Event.new(
        item_id: prev_event.item_id,
        state: prev_event.state,
        emitter: emitter,
        start_time: start_time,
        end_time: Time.now.utc,
        data: prev_event.data
      )
    end

    def failure(message)
      RegalBird::Event.new(
        item_id: prev_event.item_id,
        state: prev_event.state,
        emitter: emitter,
        start_time: start_time,
        end_time: Time.now.utc,
        data: prev_event.data.merge({error: message})
      )
    end

    private

    attr_reader :emitter, :prev_event, :start_time

  end
end
