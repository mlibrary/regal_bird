require "regal_bird/progress"
require "regal_bird/event_log"

module RegalBird
  RSpec.describe Progress do
    let(:plan) do
      double(:plan,
        initial_state: :init,
        action: double(:action_klass,
          new: double(:action,
            execute: double(:event,
              state: :some_new_state,
              data: {some: :data}
            )
          )
        )
      )
    end
    let(:progress) { described_class.new(7, plan)}

    describe "#new" do
      it "has an empty event log" do
        expect(progress.event_log).to eql(EventLog.new)
      end
    end

    describe "#run_next" do
      it "passes the current state to the plan to get the action" do
        expect(plan).to receive(:action).with(:init)
        progress.run_next
      end
      it "passes the event log to the action" do
        expect(plan.action).to receive(:new).with(progress.event_log)
        progress.run_next
      end
      it "executes the action from plan" do
        expect(plan.action.new).to receive(:execute)
        progress.run_next
      end
      it "appends the event from the action to the event log" do
        progress.run_next
        expect(progress.event_log).to eql(EventLog.new([plan.action.new.execute]))
      end
    end

  end
end
