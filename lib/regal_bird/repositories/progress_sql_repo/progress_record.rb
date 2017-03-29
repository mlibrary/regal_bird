require "progress"
require "event_log"
require "sequel"

module RegalBird
  class ProgressSqlRepo

    class ProgressRecord
      def initialize(id:, domain_id:, plan:, state:, event_log:)
        @id = id
        @domain_id = domain_id
        @plan = plan
        @state = state
        @event_log = event_log
      end

      attr_accessor :id, :domain_id, :plan, :state, :event_log

      def to_progress(plan_repo)
        progress = RegalBird::Progress.new(domain_id, plan_repo.find(plan))
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
        progress.event_log.events.each do |event|
          record.add_event(EventRecord.from_event(event))
        end
      end

      private

      def event_log
        EventLog.new(
          events.order(Sequel.asc(:start_time))
            .map{|event_record| event_record.to_event }
        )
      end

    end

  end
end