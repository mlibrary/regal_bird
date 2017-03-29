require "spec_helper"
require "repositories/progress_sql_repo"

require "sequel"
require "sqlite3"

module RegalBird
  RSpec.describe ProgressSqlRepo do
    before(:all) do
      @connection = Sequel.sqlite
      Sequel::Model.db = @connection
      @repo = described_class.new(@connection)
      @repo.migrate!
    end

    around(:example) do |example|
      @connection.transaction(rollback: :always, auto_savepoint: true) {example.run}
    end

    let(:repo) { @repo }
    it_behaves_like "a ProgressRepo"
  end
end
