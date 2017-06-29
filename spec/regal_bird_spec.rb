require "regal_bird"

RSpec.describe RegalBird do
  describe "::config" do
    let(:config) { double(:config) }
    it "defaults to a Configuration" do
      expect(RegalBird.config).to be_an_instance_of(RegalBird::Configuration)
    end
    it "can be assigned" do
      RegalBird.config = config
      expect(RegalBird.config).to eql(config)
    end
  end

  describe "::add_steward and ::emit" do
    let(:event) { double(:event)}
    let(:steward) do
      double(:steward,
        emit: nil,
        plan: double(:plan,
          name: "foo"
        )
      )
    end
    it "adds a steward for emit" do
      described_class.add_steward(steward)
      described_class.emit(steward.plan.name, event)
      expect(steward).to have_received(:emit).with(event)
    end
  end

end
