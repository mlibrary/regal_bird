# frozen_string_literal: true

require "regal_bird/messaging/polling/retry_queue_config"

module A
  module B
    class C; end
  end
end

RSpec.describe RegalBird::Messaging::Polling::RetryQueueConfig do
  let(:step) { A::B::C }
  let(:interval) { 176 }
  subject(:config) { described_class.new(step, interval) }

  let(:queue_name) { "source-a_b_c-retry" }

  describe "#channel_opts" do
    let(:wx) { double(:wx, name: "foomp") }
    it "returns the correct channel opts" do
      expect(config.channel_opts(wx)).to eql({
        exclusive: false,
        auto_delete: false,
        durable: true,
        arguments: {
          "x-dead-letter-exchange" => wx.name,
          "x-message-ttl" => interval * 1000,
          "x-max-length" => 1
        }
      })
    end
  end

  describe "#bind_opts" do
    it "matches" do
      expect(config.bind_opts).to eql({
        arguments: {
          "x-match" => "all",
          "source" => "A::B::C"
        }
      })
    end
  end

  describe "#name" do
    it "matches" do
      expect(config.name).to eql(queue_name)
    end
  end

  describe "#route" do
    it "matches" do
      expect(config.route).to eql({"source" => "A::B::C"})
    end
  end

  describe "#init_messages" do
    xit "is has a message"
  end


end
