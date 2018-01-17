# frozen_string_literal: true

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
end
