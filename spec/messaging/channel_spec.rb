require "regal_bird/messaging/channel"
require "bunny"

RSpec.describe RegalBird::Messaging::Channel do
  let(:backend_channel) { double(:backend_channel, prefetch: nil) }
  let(:connection) do
    double(:connection,
      create_channel: backend_channel,
      start: nil)
  end
  before(:each) do
    allow(Bunny).to receive(:new).and_return(connection)
  end

  it "initializes the connection" do
    expect(connection).to receive(:start)
    described_class.new
  end

  it "creates a backend channel" do
    expect(connection).to receive(:create_channel)
    described_class.new
  end

  it "sets prefetch to 1" do
    expect(backend_channel).to receive(:prefetch).with(1)
    described_class.new
  end

  it "delegates to the backend channel" do
    allow(backend_channel).to receive(:foo).and_return :bar
    expect(backend_channel).to receive(:foo).with(5)
    described_class.new.foo(5)
  end


end
