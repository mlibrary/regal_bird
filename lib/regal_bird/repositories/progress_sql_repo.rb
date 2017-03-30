require "repositories/progress_repo"
require "progress"
require "event_log"

require "repositories/progress_sql_repo/progress_record"
require "repositories/progress_sql_repo/event_record"

require "active_record"
require "pathname"

module RegalBird

  class ProgressSqlRepo

    # @param plan_repo [PlanRepo]
    def initialize(connection, plan_repo)
      @connection = connection
      @plan_repo = plan_repo
    end

    def migrate!
      ActiveRecord::Migrator.migrate(migrations_dir.to_s, nil)
    end

    def all
      ProgressRecord.all.map do |record|
        record.to_progress(plan_repo)
      end
    end

    def find(id)
      ProgressRecord.find_by_domain_id(id).to_progress(plan_repo)
    end

    def save(progress)
      ProgressRecord.transaction do
        plan_repo.save(progress.plan)
        ProgressRecord.from_progress(progress).save!
      end
    end

    def where_state(state)
      ProgressRecord.where(state: state).map do |record|
        record.to_progress(plan_repo)
      end
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