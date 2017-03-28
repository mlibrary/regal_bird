require_relative "../spec_helper"
require_relative "../job_helper"
require "jobs/init_job"
require "repo_finder"
require "event_log"
require "plan"

module RegalBird

  RSpec.describe InitJob do
    let(:repo) { double(:repo, save: nil, find: nil) }
    let(:plan) do
      double(:plan,
        name: "2c62cb43-2677-4cd7-8e28-acd50acc6f4c",
        action: double(:action_factory,
          new: double(:action, execute: nil)
        )
      )
    end
    before(:each) do
      RepoFinder.register(Plan, repo)
      allow(repo).to receive(:find).with(plan.name).and_return(plan)
      allow(plan).to receive(:action).with(:init).and_return(plan.action)
    end

    it "gets the Action factory from the plan for state :init" do
      expect(plan).to receive(:action).with(:init)
      InitJob.perform_now(plan.name)
    end

    it "invokes #new on the Action factory with a new EventLog" do
      expect(plan.action).to receive(:new).with(EventLog.new)
      InitJob.perform_now(plan.name)
    end

    it "invokes #execute on the Action" do
      expect(plan.action.new).to receive(:execute).with(no_args)
      InitJob.perform_now(plan.name)
    end

    it "saves nothing" do
      expect(repo).to_not receive(:save)
      InitJob.perform_now(plan.name)
    end

  end

end