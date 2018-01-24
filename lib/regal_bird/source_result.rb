require "regal_bird/event"

module RegalBird
  class SourceResult

    def self.for(source)
      new(source.class)
    end

    def initialize(emitter)
      @emitter = emitter.to_s
      @start_time = Time.now.utc
    end

    def success(id, state, data)
      RegalBird::Event.new(
        item_id: id,
        state: state,
        emitter: emitter,
        start_time: start_time,
        end_time: Time.now.utc,
        data: data
      )
    end

    private

    attr_reader :emitter, :start_time

  end
end
