require "regal_bird/action_result"
require "regal_bird/event"
require "timecop"
require "ostruct"

RSpec.describe RegalBird::ActionResult do
  let(:emitter) { Numeric }
  let(:data) {{zip: [1,2], zop: "new"}}
  let(:state) { :some_state }
  let(:prev_event) do
    double(
      :prev_event,
      item_id: "previd",
      state: :prev_state,
      emitter: "prev_emitter",
      start_time: Time.at(5),
      end_time: Time.at(100),
      data: { "prev" => "prev data", "zop" => 5 }
    )
  end

  let(:now) { Time.now.utc }
  let(:future) { Time.local(2095, 9, 1, 10, 5, 0) }
  let(:subject) { described_class.new(emitter, prev_event) }

  describe "#success" do
    let(:expected_event) do
      RegalBird::Event.new(
        item_id: prev_event.item_id,
        state: state,
        emitter: emitter.to_s,
        start_time: now,
        end_time: future,
        data: {
          "zip" => [1,2],
          "zop" => "new",
          "prev" => "prev data"
        }
      )
    end

    it "creates the event" do
      Timecop.freeze(now) { subject }
      Timecop.freeze(future) do
        expect(subject.success(state, data)).to eql(expected_event)
      end
    end
  end

  describe "#noop" do
    let(:expected_event) do
      RegalBird::Event.new(
        item_id: prev_event.item_id,
        state: prev_event.state,
        emitter: emitter.to_s,
        start_time: now,
        end_time: future,
        data: prev_event.data
      )
    end
    it "recreates the event" do
      Timecop.freeze(now) { subject }
      Timecop.freeze(future) do
        expect(subject.noop).to eql(expected_event)
      end
    end
  end

  describe "#failure" do
    let(:message) { "some error message\n\n\n\twith whitespace" }
    let(:expected_event) do
      RegalBird::Event.new(
        item_id: prev_event.item_id,
        state: prev_event.state,
        emitter: emitter.to_s,
        start_time: now,
        end_time: future,
        data: prev_event.data.merge({ "error" => message })
      )
    end
    it "recreates the event" do
      Timecop.freeze(now) { subject }
      Timecop.freeze(future) do
        expect(subject.failure(message)).to eql(expected_event)
      end
    end
  end
end
