require "regal_bird/event_log"

RSpec.describe RegalBird::EventLog do
  let(:event_log) { described_class.new }

  describe "#get" do
    it "returns the most recent value for the key" do
      event_log << double(:e1, data: {a: 1, b: 10})
      event_log << double(:e2, data: {a: 2, c: 1})
      expect(event_log.get(:a)).to eql(2)
    end

    it "returns nil when the key does not exist" do
      expect(event_log.get(:foo)).to eql(nil)
    end
  end

  describe "#<<" do
    it "returns self" do
      expect(event_log<<double(:e1)).to eql(event_log)
    end
  end

  describe "#where_action" do
    it "returns those events that match the action" do
      foo1 = double(:foo1, action: :foo)
      foo2 = double(:foo2, action: :foo)
      bar1 = double(:bar1, action: :bar)
      event_log << foo1 << bar1 << foo2
      expect(event_log.where_action(:foo)).to match_array([foo1, foo2])
    end
  end

  describe "#eql?" do
    it "defers to the underlying array" do
      expect(described_class.new([1,2,3])).to eql(described_class.new([1,2,3]))
    end
  end
end