require "regal_bird/repositories/plan_repo"
require "regal_bird/plan"
require "regal_bird/action"

module RegalBird
  class ActionOne < Action; end
  class ActionTwo < Action; end
  class ActionThree < Action; end
  class ActionFour < Action; end
  class ActionFive < Action; end

  RSpec.shared_examples "a PlanRepo" do
    let(:plan1) do
      RegalBird::Plan.new("plan1", {
        init: ActionOne,
        one: ActionTwo,
        two: ActionThree,
        three: ActionFour,
        four: ActionFive
      })
    end
    let(:plan2) do
      RegalBird::Plan.new("plan2", {
        init: ActionOne,
        one: ActionTwo
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
end
