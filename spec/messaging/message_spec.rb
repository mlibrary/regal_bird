require "regal_bird/messaging/message"

RSpec.describe RegalBird::Messaging::Message do
  let(:delivery_info) { double(:info, delivery_tag: "foo", routing_key: :somekey) }
  let(:properties) { double(:properties, headers: {a: 1, b: 2}) }
  let(:event) { double(:event) }
  let(:message) { described_class.new(delivery_info, properties, event) }

  it "#event" do
    expect(message.event).to eql(event)
  end
  it "#delivery_tag" do
    expect(message.delivery_tag).to eql(delivery_info.delivery_tag)
  end
  it "#headers" do
    expect(message.headers).to eql(properties.headers)
  end
  it "defaults #headers to an empty hash" do
    allow(properties).to receive(:headers).and_return nil
    expect(message.headers).to eql({})
  end
  it "#routing_key" do
    expect(message.routing_key).to eql(delivery_info.routing_key)
  end

end
