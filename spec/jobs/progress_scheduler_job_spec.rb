require_relative "../spec_helper"
require_relative "../job_helper"
require "jobs/progress_scheduler_job"
require "jobs/next_job"
require "repo_finder"
require "progress"

module RegalBird

  RSpec.describe ProgressSchedulerJob do
    let(:repo) do
      double(:repo,
        all: [
          double(:p1, id: "first"),
          double(:p2, id: "second")
        ]
      )
    end

    before(:each) do
      RepoFinder.register(Progress, repo)
    end

    it "Enqueues a NextJob for each known Progress" do
      expect(NextJob).to receive(:perform_later).once.with("first")
      expect(NextJob).to receive(:perform_later).once.with("second")
      described_class.perform_now
    end

  end

end