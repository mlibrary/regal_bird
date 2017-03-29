require "event"
require "sequel"
require "json"

module RegalBird
  class ProgressSqlRepo

    class EventRecord
      def initialize(id:, progress_id:, action:, state:, start_time:, end_time:, data:)
        @id = id
        @progress_id = progress_id
        @action = action
        @start_time = start_time
        @end_time = end_time
        @data = data
      end

      attr_accessor :action, :state, :start_time, :end_time

      def to_event
        RegalBird::Event.new(
          action: action, state: state,
          start_time: start_time, end_time: end_time,
          data: deserialize(data)
        )
      end

      def self.from_event(event)
        new(
          action: event.action, state: event.state,
          start_time: event.start_time, end_time: event.end_time,
          data: serialize(event.data)
        )
      end

      private

      attr_accessor :data

      def deserialize(stuff)
        return stuff unless stuff.is_a? String
        JSON.parse(stuff, symbolize_names: true)
      end

      def serialize(stuff)
        return stuff if stuff.is_a? String
        JSON.dump(stuff)
      end

    end

  end
end