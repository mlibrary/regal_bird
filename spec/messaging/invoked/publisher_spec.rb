require "regal_bird/messaging/invoked/publisher"
require "regal_bird/messaging/invoked/retry_queue"
require "regal_bird/messaging/event_serializer"
require "regal_bird/event"

RSpec.describe RegalBird::Messaging::Invoked::Publisher do
  let(:work_exchange) { double(:work_exchange, publish: nil, channel: "some_channel") }
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
  let(:err_msg) { "some_error_msg" }

  describe "#retry" do
    before(:each) do
      allow(RegalBird::Messaging::Invoked::RetryQueue)
        .to receive(:new).and_return(double(:queue))
    end
    let(:message) do
      double(:message,
        routing_key: "some_routing_key",
        headers: { some: { header: "data" }},
        event: event
      )
    end
    it "creates a retry queue for the new ttl" do
      expect(RegalBird::Messaging::Invoked::RetryQueue).to receive(:new).with(
        work_exchange.channel,
        work_exchange,
        retry_exchange,
        message.headers.fetch("retry-wait", 1) * 2
      )
      publisher.retry(message, err_msg)
    end
    it "publishes to the retry exchange" do
      expect(retry_exchange).to receive(:publish).with(
        json,
        {
          routing_key: message.routing_key,
          headers: message.headers.merge({
            "retry-wait" => message.headers.fetch("retry-wait", 1) * 2,
            "error" => err_msg
          })
        }
      )
      publisher.retry(message, err_msg)
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
