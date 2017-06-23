require "regal_bird/messaging/invoked/arrangement"
require "regal_bird/messaging/invoked/consumer"
require "regal_bird/messaging/invoked/publisher"
require "regal_bird/messaging/invoked/work_queue"

RSpec.describe RegalBird::Messaging::Invoked::Arrangement do
  let(:channel) { double(:channel) }
  let(:work_exchange) { double(:work_exchange) }
  let(:retry_exchange) { double(:retry_exchange) }
  let(:step_class) { Fixnum }
  let(:state) { :some_state }
  let(:num_workers) { rand(1..5) }
  let(:arrangement) { described_class.new(channel, work_exchange, retry_exchange, step_class, state, num_workers) }

  let(:publisher) { double(:publisher, success: nil, retry: nil) }
  let(:retry_queue) { double(:retry_queue, binding: "foo") }
  let(:work_queue) { double(:work_queue) }

  before(:each) do
    allow(RegalBird::Messaging::Invoked::Consumer).to receive(:new)
    allow(RegalBird::Messaging::Invoked::Publisher).to receive(:new).and_return(publisher)
    allow(RegalBird::Messaging::Invoked::WorkQueue).to receive(:new).and_return(work_queue)
  end

  describe "::new" do
    it "creates num_workers Consumer instances" do
      expect(RegalBird::Messaging::Invoked::Consumer).to receive(:new)
        .exactly(num_workers).times
        .with(work_queue, publisher, step_class)
      arrangement
    end

    it "creates a Publisher" do
      expect(RegalBird::Messaging::Invoked::Publisher).to receive(:new)
        .with(work_exchange, retry_exchange)
      arrangement
    end

    it "creates a WorkQueue" do
      expect(RegalBird::Messaging::Invoked::WorkQueue).to receive(:new)
        .with(channel, work_exchange, step_class, "action.#{state.to_s}")
      arrangement
    end

  end
end
