require "regal_bird/plan"

RSpec.describe RegalBird::Plan do

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

end