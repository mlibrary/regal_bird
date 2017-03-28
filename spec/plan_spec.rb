require "regal_bird/plan"

RSpec.describe RegalBird::Plan do
  let(:plan1) do
    described_class.new("plan1", {
      init: :action1,
      one: :action2
    })
  end
  let(:plan2) do
    described_class.new("plan2", {
      init: :start,
      one: :finish,
      two: :finish
    })
  end

  describe "#name" do
    it "returns the name" do
      expect(described_class.new("some_name", {}).name).to eql("some_name")
    end
  end

  describe "#action" do
    it "returns the Action for the given state" do
      plan = described_class.new(:name, {init: :some_action})
      expect(plan.action(:init)).to eql(:some_action)
    end
  end

  [:eql?, :==].each do |method|
    describe "##{method}" do
      it "is true if the names and maps are identical" do
        p1 = described_class.new("plan1", {
          init: :action1,
          one: :action2
        })
        p2 = described_class.new("plan1", {
          init: :action1,
          one: :action2
        })
        expect(p1.eql?(p2)).to be true
        expect(p1 == p2).to be true
      end
      it "is false if names match, maps mismatch" do
        p1 = described_class.new("plan1", {
          init: :action1,
          one: :action2
        })
        p2 = described_class.new("plan1", {
          init: :action1,
          one: :action2,
          two: :finish
        })
        expect(p1.eql?(p2)).to be false
        expect(p1 == p2).to be false
      end
      it "is false if names mismatch, maps match" do
        p1 = described_class.new("plan1", {
          init: :action1,
          one: :action2
        })
        p2 = described_class.new("other_plan", {
          init: :action1,
          one: :action2
        })
        expect(p1.eql?(p2)).to be false
        expect(p1 == p2).to be false
      end
    end
  end


end