# frozen_string_literal: true

require "regal_bird/messaging/event_serializer"
require "regal_bird/event"
require "active_support/core_ext/time"
require "json"

RSpec.describe RegalBird::Messaging::EventSerializer do
  let(:opts) do
    {
      item_id: "foo", emitter: "My::Action", state: :ready,
      data: { some: [1, 2, 3], stuff: "foo" },
      start_time: Time.at(1_231_231), end_time: Time.now
    }
  end
  let(:event) { RegalBird::Event.new(opts) }
  let(:json) do
    JSON.generate(item_id: opts[:item_id], emitter: opts[:emitter],
      state: opts[:state], data: opts[:data],
      start_time: opts[:start_time].iso8601(9),
      end_time: opts[:end_time].iso8601(9))
  end
  it "::serialize produces proper json" do
    expect(described_class.serialize(event)).to eql(json)
  end

  it "::deserialize produces the event" do
    expect(described_class.deserialize(json)).to eql(event)
  end
end
