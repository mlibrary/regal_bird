# frozen_string_literal: true

require "regal_bird/plan"
require "regal_bird/plan_dsl"

RSpec.describe RegalBird::PlanDSL do
  let(:name) { "malakai97" }
  class TestLogger; end

  describe "#source" do
    let!(:decl) { RegalBird::Plan::SourceDeclaration.new(Integer, 85) }
    it "adds a source declaration" do
      plan = RegalBird::Plan.define(name) { source Integer, 85 }
      expect(plan.sources).to contain_exactly(decl)
    end
  end

  describe "#action" do
    let!(:decl) { RegalBird::Plan::ActionDeclaration.new(Hash, :foomp, 3) }
    it "adds an action declaration" do
      plan = RegalBird::Plan.define(name) { action :foomp, Hash, 3 }
      expect(plan.actions).to contain_exactly(decl)
    end
  end

  describe "#logger" do
    it "sets the plan's logger" do
      plan = RegalBird::Plan.define(name) { logger TestLogger.new }
      expect(plan.logger).to be_an_instance_of(TestLogger)
    end
  end
end
