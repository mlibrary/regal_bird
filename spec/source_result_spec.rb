require "regal_bird/source_result"
require "timecop"

RSpec.describe RegalBird::SourceResult do
  describe "#success" do
    let(:id) { "55" }
    let(:emitter) { Numeric }
    let(:state) { :somestate }
    let(:data) { { zip: [1,2], zop: "foo" } }
    let(:expected_event) do
      RegalBird::Event.new(
        item_id: id,
        emitter: emitter.to_s,
        state: state,
        start_time: now,
        end_time: future,
        data: {
          "zip" => [1,2],
          "zop" => "foo"
        }
      )
    end
    let(:now) { Time.now.utc }
    let(:future) { Time.local(2095, 9, 1, 10, 5, 0) }
    let(:subject) { described_class.new(emitter) }

    it "creates the event" do
      Timecop.freeze(now) { subject}
      Timecop.freeze(future) do
        expect(subject.success(id, state, data)).to eql(expected_event)
      end
    end

  end
end
