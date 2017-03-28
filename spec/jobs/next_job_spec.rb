require_relative "../spec_helper"
require_relative "../job_helper"
require "jobs/next_job"
require "repo_finder"
require "progress"

module RegalBird

  RSpec.describe NextJob do
    let(:repo) { double(:repo, save: nil, find: nil) }
    let(:id) { "2c62cb43-2677-4cd7-8e28-acd50acc6f4c" }
    let(:progress)  { double(:progress, run_next: nil) }
    before(:each) do
      RepoFinder.register(Progress, repo)
      allow(repo).to receive(:find).with(id).and_return(progress)
    end
    it "invokes #run_next on the Progress object" do
      expect(progress).to receive(:run_next)
      NextJob.perform_now(id)
    end
    it "saves the Progress object" do
      expect(repo).to receive(:save).with(progress)
      NextJob.perform_now(id)
    end
  end

end