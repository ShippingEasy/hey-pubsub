require "spec_helper"

describe Hey::Pubsub::Adapters::AsnAdapter do
  after do
    Thread.current[:recorded_payload] = nil
  end

  it "responds to .publish!" do
    expect(described_class).to respond_to(:publish!)
  end

  it "responds to .subscribe!" do
    expect(described_class).to respond_to(:subscribe!)
  end

  it "can publish and subscribe to a hash" do
    event_payload = { name: "Jack Ship" }

    Hey::Pubsub::Adapters::AsnAdapter.subscribe!("registration_completed") do |payload|
      Thread.current[:recorded_payload] = payload
    end

    Hey::Pubsub::Adapters::AsnAdapter.publish!(Hey::Pubsub::Event.new(name: "registration_completed", metadata: event_payload))

    expect(Thread.current[:recorded_payload][:metadata]).to eq(event_payload)
  end
end
