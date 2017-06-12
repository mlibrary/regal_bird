require "regal_bird/action"
require "regal_bird/event"

RSpec.describe RegalBird::Action do
  let(:event) { double(:event, item_id: "55", state: :some_state, data: {f: 5, c: 6}) }
  let(:action) { described_class.new(event) }

  describe "#noop" do
    it "has the previous state" do
      expect(action.noop[:state]).to eql(:some_state)
    end
    it "has no data" do
      expect(action.noop[:data]).to eql({})
    end
    it "has no extra keys" do
      expect(action.noop.keys).to contain_exactly(:state, :data)
    end
  end

  describe "#success" do
    let(:new_state) { :new_state }
    let(:new_data) { {a: 2, b: 3} }
    it "has the new state" do
      expect(action.success(new_state, new_data)[:state]).to eql(new_state)
    end
    it "has the new data" do
      expect(action.success(new_state, new_data)[:data]).to eql(new_data)
    end
    it "has no extra keys" do
      expect(action.success(new_state, new_data).keys).to contain_exactly(:state, :data)
    end
  end

  describe "#failure" do
    let(:message) { "there was a problem, captain" }
    it "has the previous state" do
      expect(action.failure(message)[:state]).to eql(:some_state)
    end
    it "assigns the message to data[:error]" do
      expect(action.failure(message)[:data]).to eql({error: message})
    end
    it "has no extra keys" do
      expect(action.failure(message).keys).to contain_exactly(:state, :data)
    end
  end

  describe "#wrap_execution" do
    let(:state) { :some_state }
    let(:data) { {a: 2, b: [1,2,3]} }
    let(:result) { {state: :some_state, data: data} }
    context "block raises no error" do
      it "returns an event" do
        expect(action.wrap_execution{result}).to be_an_instance_of(RegalBird::Event)
      end
      it "returns an event with item_id == previous item_id" do
        expect(action.wrap_execution{result}.item_id).to eql(event.item_id)
      end
      it "returns an event with action == self.class.to_s.to_sym" do
        expect(action.wrap_execution{result}.action).to eql(described_class.to_s)
      end
      it "returns an event with state == block.call[:state]" do
        expect(action.wrap_execution{result}.state).to eql(state)
      end
      it "returns an event with data == previous.merge(block.call[:data])" do
        expect(action.wrap_execution{result}.data).to eql(event.data.merge(data))
      end
      it "manages start_time and end_time" do
        mid_time = nil
        actual = action.wrap_execution do
          mid_time = Time.now.utc
          result
        end
        expect(actual.start_time).to be < mid_time
        expect(actual.end_time).to be > mid_time
      end


    end
  end


end
