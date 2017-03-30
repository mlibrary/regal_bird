require "progress"
require "event_log"
require "active_record"
# require "regal_bird/repositories/progress_sql_repo/event_record"

module RegalBird
  class ProgressSqlRepo

    class ProgressRecord < ActiveRecord::Base
      has_many :events, inverse_of: :progress, class_name: "EventRecord",
        foreign_key: :progress_id

      def self.table_name
        :progresses
      end

      def to_progress(plan_repo)
        progress = Progress.new(domain_id, plan_repo.find(plan))
        progress.event_log = event_log
        return progress
      end

      def self.from_progress(progress)
        record = new(
          id: nil,
          domain_id: progress.id,
          plan: progress.plan.name,
          state: progress.state
        )
        record.events = progress.event_log.events.map do |event|
          EventRecord.from_event(event)
        end
        return record
      end

      private

      def event_log
        EventLog.new(
          events.order(start_time: :asc)
            .map{|event_record| event_record.to_event }
        )
      end

    end

  end
end