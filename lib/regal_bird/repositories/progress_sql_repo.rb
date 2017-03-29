require "repositories/progress_repo"
require "progress"
require "event_log"

require "repositories/progress_sql_repo/progress_record"
require "repositories/progress_sql_repo/event_record"

require "sequel"

module RegalBird

  class ProgressSqlRepo < ProgressRepo

    # @param plan_repo [PlanRepo]
    def initialize(connection, plan_repo)
      @connection = connection
      @plan_repo = plan_repo
    end

    def migrate!
      Sequel.extension :migration
      Sequel::Migrator.run(connection, migrations_dir.to_s)
    end

    def all
      ProgressRecord.all.map do |record|
        record.to_progress(plan_repo)
      end
    end

    def find(id)
      ProgressRecord[progress_id: id].to_progress(plan_repo)
    end

    def save(progress)
      @connection.transaction do
        plan_repo.save(progress.plan)
        ProgressRecord[progress_id: progress.id].delete
        ProgressRecord.from_progress(progress).save
      end
    end

    def where_state(state)
      # EventRecord.group(:progress_id)
    end

    private

    attr_reader :connection, :plan_repo

    def table
      connection[:progresses]
    end

    def migrations_dir
      Pathname.new(__FILE__).dirname + "progress_sql_repo" + "migrations"
    end

  end

end