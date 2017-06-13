require "regal_bird/messaging/retry_exchange"

RSpec.describe RegalBird::Messaging::RetryExchange do
  let(:name) { "some-exchange" }
  let(:backend_exchange) { double(:exchange) }
  let(:channel) do
    double(:channel,
      queue: double(:queue),
      headers: backend_exchange
    )
  end

  it "initializes a durable headers exchange" do
    expect(channel).to receive(:headers)
      .with(name, { durable: true, auto_delete: false})
    described_class.new(name, channel)
  end

  it "delegates to the backend exchange" do
    allow(backend_exchange).to receive(:foo).and_return :bar
    expect(backend_exchange).to receive(:foo).with(5)
    described_class.new(name, channel).foo(5)
  end

end
