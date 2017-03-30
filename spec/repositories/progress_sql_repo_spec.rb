require "spec_helper"
require "repositories/progress_sql_repo"
require "repositories/memory_repo"

require "active_record"
require "sqlite3"

module RegalBird
  RSpec.describe ProgressSqlRepo do
    before(:all) do
      @connection = ActiveRecord::Base.establish_connection(
        adapter: "sqlite3", database: ":memory:"
      )
      described_class.new(@connection, nil).migrate!
    end

    around(:each) do |test|
      ActiveRecord::Base.transaction do
        test.run
        raise ActiveRecord::Rollback
      end
    end

    let(:repo) { described_class.new(@connection, MemoryRepo.new) }
    it_behaves_like "a ProgressRepo"
  end
end
