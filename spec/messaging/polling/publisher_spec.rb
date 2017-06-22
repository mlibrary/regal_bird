require "regal_bird/messaging/polling/publisher"
require "regal_bird/messaging/event_serializer"
require "regal_bird/event"

RSpec.describe RegalBird::Messaging::Polling::Publisher do
  let(:work_exchange) { double(:work_exchange, publish: nil) }
  let(:retry_exchange) { double(:retry_exchange, publish: nil) }
  let(:publisher) { described_class.new(work_exchange, retry_exchange) }
  let(:event_opts) do
    {
      item_id: "derp", emitter: "test", state: :ready,
      data: { some: "data", more: [1,2,3] },
      start_time: Time.at(0), end_time: Time.now
    }
  end
  let(:event) { RegalBird::Event.new(event_opts)}
  let(:json) { RegalBird::Messaging::EventSerializer.serialize(event) }

  describe "#retry" do
    let(:message) do
      double(:message,
        routing_key: "some_routing_key",
        headers: { some: { header: "data" }},
        event: event
      )
    end
    it "publishes to the retry exchange" do
      expect(retry_exchange).to receive(:publish).with(
        json,
        { routing_key: message.routing_key, headers: message.headers }
      )
      publisher.retry(message)
    end
  end

  describe "#success" do
    it "publishes to the work exchange" do
      expect(work_exchange).to receive(:publish).with(
        json,
        { routing_key: "action.#{event_opts[:state].to_s}"}
      )
      publisher.success(event)
    end
  end

end
