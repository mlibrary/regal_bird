# frozen_string_literal: true

require "regal_bird/messaging/polling/work_queue_config"

module A
  module B
    class C; end
  end
end

RSpec.describe RegalBird::Messaging::Polling::WorkQueueConfig do
  let(:step) { A::B::C }
  let(:routing_key) { "sometest.routing.key" }
  subject(:config) { described_class.new(step, routing_key) }

  let(:queue_name) { "source-a_b_c-work" }

  describe "#channel_opts" do
    it "returns the correct channel opts" do
      expect(config.channel_opts(nil)).to eql({
        exclusive: false,
        auto_delete: false,
        durable: true,
        arguments: { "x-max-length" => 1 }
      })
    end
  end

  describe "#bind_opts" do
    it "returns the route" do
      expect(config.bind_opts).to eql({routing_key: routing_key})
    end
  end

  describe "#name" do
    it "matches" do
      expect(config.name).to eql(queue_name)
    end
  end

  describe "#route" do
    it "matches" do
      expect(config.route).to eql({routing_key: routing_key})
    end
  end

  describe "#init_messages" do
    it "is empty" do
      expect(config.init_messages).to eql([])
    end
  end

end
