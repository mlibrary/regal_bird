require "regal_bird/repositories/plan_repo"
require "regal_bird/plan"


Rspec.shared_examples "a PlanRepo" do
  let(:plan1) do
    RegalBird::Plan.define("plan1") do
      add(:init,  double(:action1))
      add(:one,   double(:action2))
      add(:two,   double(:action3))
      add(:three, double(:action4))
      add(:four,  double(:action5))
      add(:five,  double(:action6))
    end
  end
  let(:plan2) do
    RegalBird::Plan.define("plan2") do
      add(:init,  double(:start))
      add(:one,   double(:finish))
    end
  end

  describe "#save, #find" do
    it "saves and returns plans by name" do
      repo.save(plan1)
      repo.save(plan2)
      expect(repo.find(plan1.name)).to eql(plan1)
      expect(repo.find(plan2.name)).to eql(plan2)
    end
  end

  describe "#all" do
    it "returns all records" do
      repo.save(plan1)
      repo.save(plan2)
      expect(repo.all).to contain_exactly(plan1, plan2)
    end
  end

end