require "regal_bird/plan"

RSpec.describe RegalBird::Plan do
  let(:empty_plan) { described_class.new("empty_plan") }
  describe "#name" do
    it "returns the name" do
      expect(empty_plan.name).to eql("empty_plan")
    end
  end

  describe "#add_action_declaration" do
    let(:declaration) { RegalBird::Plan::ActionDeclaration.new(Fixnum, :ready, 5) }
    it "adds the action" do
      expect { empty_plan.add_action_declaration(declaration) }
        .to change { empty_plan.actions }
        .from([])
        .to([declaration])
    end
    it "returns self" do
      expect(empty_plan.add_action_declaration(declaration)).to eql(empty_plan)
    end
  end

  describe "#add_action" do
    let(:declaration) { RegalBird::Plan::ActionDeclaration.new(Fixnum, :ready, 5) }
    it "adds the action" do
      expect { empty_plan.add_action(Fixnum, :ready, 5) }
        .to change { empty_plan.actions }
        .from([])
        .to([declaration])
    end
    it "returns self" do
      expect(empty_plan.add_action(Fixnum, :ready, 5)).to eql(empty_plan)
    end
  end

  describe "#add_source_declaration" do
    let(:declaration) { RegalBird::Plan::SourceDeclaration.new(Fixnum, 60) }
    it "adds the source" do
      expect { empty_plan.add_source_declaration(declaration) }
        .to change { empty_plan.sources }
        .from([])
        .to([declaration])
    end
    it "returns self" do
      expect(empty_plan.add_source_declaration(declaration)).to eql(empty_plan)
    end
  end

  describe "#add_source" do
    let(:declaration) { RegalBird::Plan::SourceDeclaration.new(Fixnum, 60) }
    it "adds the action" do
      expect { empty_plan.add_source(Fixnum, 60) }
        .to change { empty_plan.sources }
        .from([])
        .to([declaration])
    end
    it "returns self" do
      expect(empty_plan.add_source(Fixnum, 60)).to eql(empty_plan)
    end
  end

  describe "#eql?" do
    let(:foo_a_b) do
      described_class.new("foo")
        .add_source(Fixnum, 45)
        .add_action(String, :ready, 5)
    end
    let(:foo_b_a) do
      described_class.new("foo")
        .add_action(String, :ready, 5)
        .add_source(Fixnum, 45)
    end
    let(:bar_a_b) do
      described_class.new("bar")
        .add_action(String, :ready, 5)
        .add_source(Fixnum, 45)
    end
    let(:foo_a_b_c) do
      described_class.new("foo")
        .add_source(Fixnum, 45)
        .add_action(String, :ready, 5)
        .add_action(Hash, :done, 5)
    end
    it "is true if names match, declarations match" do
      expect(foo_a_b.eql?(foo_b_a)).to be true
      expect(foo_a_b == foo_b_a).to be true
    end
    it "is false if names diff, declarations match" do
      expect(foo_a_b.eql?(bar_a_b)).to be false
      expect(foo_a_b == bar_a_b).to be false
    end
    it "is false if names match, declarations diff" do
      expect(foo_a_b.eql?(foo_a_b_c)).to be false
      expect(foo_a_b == foo_a_b_c).to be false
    end
  end

end
