require "event"
require "active_record"
require "json"

module RegalBird
  class ProgressSqlRepo

    class EventRecord < ActiveRecord::Base
      belongs_to :progress, inverse_of: :events, class_name: "ProgressRecord"
      serialize :data

      def self.table_name
        :events
      end

      def to_event
        RegalBird::Event.new(
          action: action, state: state,
          start_time: start_time, end_time: end_time,
          data: data
        )
      end

      def self.from_event(event)
        new(
          action: event.action, state: event.state,
          start_time: event.start_time, end_time: event.end_time,
          data: event.data
        )
      end

    end

  end
end