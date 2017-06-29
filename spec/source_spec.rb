# frozen_string_literal: true

require "regal_bird/source"
require "regal_bird/event"

RSpec.describe RegalBird::Source do
  describe "#wrap_execution" do
    let(:source) { described_class.new }
    let(:result_1) { { item_id: "1", state: :foo_state, data: { zip: [12, 34] } } }
    let(:result_2) { { item_id: "2", state: :bar_state, data: {} } }
    let(:results) { [result_1, result_2] }
    let(:emitter) { described_class.to_s }

    context "block raises no error" do
      it "returns an array of events" do
        expect(source.wrap_execution { results })
          .to contain_exactly(
            an_instance_of(RegalBird::Event),
            an_instance_of(RegalBird::Event)
)
      end
      it "returns events with action == self.class.to_s" do
        events = source.wrap_execution { results }
        expect(events.map(&:emitter)).to contain_exactly(emitter, emitter)
      end
      it "returns events with state == block.call[:state]" do
        events = source.wrap_execution { results }
        expect(events.map(&:state)).to contain_exactly(result_1[:state], result_2[:state])
      end
      it "returns events with data == block.call[:data]" do
        events = source.wrap_execution { results }
        expect(events.map(&:data)).to contain_exactly(result_1[:data], result_2[:data])
      end
      it "manages start_time and end_time" do
        mid_time = nil
        actual = source.wrap_execution do
          mid_time = Time.now.utc
          results
        end
        actual.each do |result|
          expect(result.start_time).to be < mid_time
          expect(result.end_time).to be > mid_time
        end
      end
    end
  end
end
