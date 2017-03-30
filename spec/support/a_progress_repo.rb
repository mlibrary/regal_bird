require "regal_bird/repositories/progress_repo"
require "regal_bird/progress"
require "regal_bird/plan"
require "regal_bird/event"
require "regal_bird/event_log"

class Action1; end
class Action2; end
class Action3; end

RSpec.shared_examples "a ProgressRepo" do
  let(:event1) do
    RegalBird::Event.new(
      action: :action2, state: :three,
      start_time: Time.at(1000), end_time: Time.at(1500),
      data: {some: {nested: [:da, :ta]}}
    )
  end
  let(:event2) do
    RegalBird::Event.new(
      action: :action3, state: :complete,
      start_time: Time.at(100550), end_time: Time.at(155500),
      data: {}
    )
  end
  let(:progress1) do
    RegalBird::Progress.new("4e79f6ed-8b56-4e9b-9c9d-e1c75ca9dd94",
      RegalBird::Plan.new("plan1", {
        init: Action1,
        one:  Action2,
        two:  Action3,
      }),
      RegalBird::EventLog.new([event1, event2])
    )
  end
  let(:progress2) do
    RegalBird::Progress.new("04338a3d-c5b3-4502-90a3-04b8dcf357c0",
      RegalBird::Plan.new("plan1", {
        init: Action1,
        one:  Action2,
        two:  Action3,
      }),
      RegalBird::EventLog.new
    )
  end

  describe "#save, #find" do
    it "saves and finds progress instances by id" do
      repo.save(progress1)
      repo.save(progress2)
      expect(repo.find(progress1.id)).to eql(progress1)
      expect(repo.find(progress2.id)).to eql(progress2)
    end
  end

  describe "#all" do
    it "returns all records" do
      repo.save(progress1)
      repo.save(progress2)
      expect(repo.all).to contain_exactly(progress1, progress2)
    end
  end

  describe "#where_state" do
    it "returns records that match the state" do
      repo.save(progress1)
      repo.save(progress2)
      expect(repo.where_state(progress2.state)).to contain_exactly(progress2)
    end
  end






end
