# frozen_string_literal: true

require "regal_bird/event"

RSpec.describe RegalBird::Event do
  let(:event) do
    described_class.new(
      item_id: "some_item_id",
      emitter: "something",
      state: :some_state,
      data: { some: :data },
      start_time: Time.at(0),
      end_time: Time.at(1000)
    )
  end

  it "#item_id" do
    expect(event.item_id).to eql("some_item_id")
  end

  it "#emitter" do
    expect(event.emitter).to eql("something")
  end

  it "#state" do
    expect(event.state).to eql(:some_state)
  end

  it "#data" do
    expect(event.data).to eql(some: :data)
  end

  it "#start_time" do
    expect(event.start_time).to eql(Time.at(0))
  end

  it "#end_time" do
    expect(event.end_time).to eql(Time.at(1000))
  end
end
