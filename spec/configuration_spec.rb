# frozen_string_literal: true

require "regal_bird/configuration"
require "pathname"

RSpec.describe RegalBird::Configuration do
  let(:config) { described_class.new }

  describe "#plan_dir, #plan_dir=" do
    it "has no default" do
      expect(config.plan_dir).to be_nil
    end
    it "converts strings to Pathnames" do
      expect { config.plan_dir = "some/dir" }
        .to change { config.plan_dir }
        .to Pathname.new("some/dir")
    end
    it "accepts Pathnames" do
      expect { config.plan_dir = Pathname.pwd }
        .to change { config.plan_dir }
        .to Pathname.pwd
    end
  end

  describe "#valid?" do
    let(:full_config) { described_class.new(plan_dir: Pathname.pwd) }
    it "is invalid when plan_dir is nil" do
      full_config.plan_dir = nil
      expect(config.valid?).to be false
    end
  end

  it "allows arbitrary fields to be added" do
    expect { config.foo = :bar }
      .to change { config.foo }
      .from(nil).to(:bar)
  end
end
