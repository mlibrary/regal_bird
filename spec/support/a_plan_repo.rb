require "regal_bird/repositories/plan_repo"
require "regal_bird/plan"


RSpec.shared_examples "a PlanRepo" do
  let(:plan1) do
    RegalBird::Plan.new("plan1", {
      init: :action1,
      one: :action2,
      two: :action3,
      three: :action4,
      four: :action5,
      five: :action6
    })
  end
  let(:plan2) do
    RegalBird::Plan.new("plan2", {
      init: :action1,
      one: :action2
    })
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