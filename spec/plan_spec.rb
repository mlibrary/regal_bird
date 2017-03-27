require "regal_bird/plan"

RSpec.describe RegalBird::Plan do

  describe "::define" do
    it "returns an instance" do
      expect(described_class.define {true}).to be_an_instance_of described_class
    end
    it "allows use of #add" do
      expect {
        described_class.define { add(:state, :action)}
      }.to_not raise_error
    end
    describe "#add" do
      it "registers a state:Action pair" do
        plan = described_class.define { add(:init, :some_action) }
        expect(plan.action(:init)).to eql(:some_action)
      end
    end
  end

  describe "#action" do
    it "returns the Action for the given state" do
      plan = described_class.define { add(:init, :some_action) }
      expect(plan.action(:init)).to eql(:some_action)
    end
  end

end