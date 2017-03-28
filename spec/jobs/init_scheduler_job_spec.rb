require_relative "../spec_helper"
require_relative "../job_helper"
require "jobs/init_scheduler_job"
require "jobs/init_job"
require "repo_finder"
require "plan"

module RegalBird

  RSpec.describe InitSchedulerJob do
    let(:repo) do
      double(:repo,
        all: [
          double(:plan1, name: "first"),
          double(:plan2, name: "second")
        ]
      )
    end

    before(:each) do
      RepoFinder.register(Plan, repo)
    end

    it "Enqueues an InitJob for each known Plan" do
      expect(InitJob).to receive(:perform_later).once.with("first")
      expect(InitJob).to receive(:perform_later).once.with("second")
      InitSchedulerJob.perform_now
    end

  end

end