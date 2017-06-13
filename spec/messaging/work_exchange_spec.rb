require "regal_bird/messaging/work_exchange"

RSpec.describe RegalBird::Messaging::WorkExchange do
  let(:name) { "some-exchange" }
  let(:backend_exchange) { double(:exchange) }
  let(:channel) { double(:channel, topic: backend_exchange) }

  it "initializes a durable topic exchange" do
    expect(channel).to receive(:topic)
      .with(name, { durable: true, auto_delete: false})
    described_class.new(name, channel)
  end

  it "delegates to the backend exchange" do
    allow(backend_exchange).to receive(:foo).and_return :bar
    expect(backend_exchange).to receive(:foo).with(5)
    described_class.new(name, channel).foo(5)
  end

end
