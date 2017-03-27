require "regal_bird/plan"

RSpec.describe RegalBird::Plan do
  let(:plan1) do
    described_class.define("plan1") do
      add(:init,  double(:action1))
      add(:one,   double(:action2))
    end
  end
  let(:plan2) do
    described_class.define("plan2") do
      add(:init,  double(:start))
      add(:one,   double(:finish))
      add(:two,   double(:finish))
    end
  end

  describe "#name" do
    it "returns the name" do
      expect(described_class.new("some_name").name).to eql("some_name")
    end
  end

  describe "::define" do
    it "returns an instance" do
      expect(described_class.define(:name) {true}).to be_an_instance_of described_class
    end
    it "assigns the name" do
      plan = described_class.define(:name) {true}
      expect(plan.name).to eql(:name)
    end
    it "allows use of #add" do
      expect {
        described_class.define(:name) { add(:state, :action)}
      }.to_not raise_error
    end
    describe "#add" do
      it "registers a state:Action pair" do
        plan = described_class.define(:name) { add(:init, :some_action) }
        expect(plan.action(:init)).to eql(:some_action)
      end
    end
  end

  describe "#action" do
    it "returns the Action for the given state" do
      plan = described_class.define(:name) { add(:init, :some_action) }
      expect(plan.action(:init)).to eql(:some_action)
    end
  end



  [:eql?, :==].each do |method|
    describe "##{method}" do
      it "is true if the names and maps are identical" do
        p1 = described_class.define("plan1") do
          add(:init,  :action1)
          add(:one,   :action2)
        end
        p2 = described_class.define("plan1") do
          add(:init,  :action1)
          add(:one,   :action2)
        end
        expect(p1.eql?(p2)).to be true
        expect(p1 == p2).to be true
      end
      it "is false if names match, maps mismatch" do
        p1 = described_class.define("plan1") do
          add(:init,  :action1)
          add(:one,   :action2)
        end
        p2 = described_class.define("plan1") do
          add(:init,  :action1)
          add(:one,   :some_other_action)
        end
        expect(p1.eql?(p2)).to be false
        expect(p1 == p2).to be false
      end
      it "is false if names mismatch, maps match" do
        p1 = described_class.define("plan1") do
          add(:init,  :action1)
          add(:one,   :action2)
        end
        p2 = described_class.define("other_plan") do
          add(:init,  :action1)
          add(:one,   :action2)
        end
        expect(p1.eql?(p2)).to be false
        expect(p1 == p2).to be false
      end
    end
  end


end