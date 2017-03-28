require "regal_bird/repositories/progress_repo"
require "regal_bird/progress"
require "regal_bird/plan"


Rspec.shared_examples "a ProgressRepo" do
  let(:progress1) do
    RegalBird::Progress.new("4e79f6ed-8b56-4e9b-9c9d-e1c75ca9dd94",
      RegalBird::Plan.define("plan1") do
        add(:init,  double(:action1))
        add(:one,   double(:action2))
        add(:two,   double(:action3))
      end
    )
  end
  let(:progress2) do
    RegalBird::Progress.new("04338a3d-c5b3-4502-90a3-04b8dcf357c0",
      RegalBird::Plan.define("plan1") do
        add(:init,  double(:action1))
        add(:one,   double(:action2))
        add(:two,   double(:action3))
      end
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
      progress1.state = :one
      progress2.sate = :init
      repo.save(progress1)
      repo.save(progress2)
      expect(repo.where_state(:init)).to contain_exactly(progress2)
    end
  end






end
