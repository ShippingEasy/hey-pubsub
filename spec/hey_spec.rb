require "spec_helper"

describe Hey do
  let(:event_name) { "registration_creation.succeeded" }
  let(:payload) do
    { name: "Bing Bong" }
  end

  describe ".pubsub_adapter" do
    it "delegates to configuration" do
      Hey::Configuration.any_instance.stub(:pubsub_adapter)
      Hey.pubsub_adapter
      expect(Hey.configuration).to have_received(:pubsub_adapter)
    end
  end

  describe ".subscribe!" do
    it "delegates to the adapter" do
      Hey.pubsub_adapter.stub(:subscribe!)
      Hey.subscribe!(event_name)
      expect(Hey.pubsub_adapter).to have_received(:subscribe!).with(event_name)
    end
  end

  describe ".publish!" do
    it "delegates to the adapter" do
      Hey.pubsub_adapter.stub(:publish!)
      Hey.publish!(event_name, payload)
      expect(Hey.pubsub_adapter).to have_received(:publish!).with(event_name, payload)
    end
  end

  describe ".sanitize!" do
    it "delegates to the thread cargo class" do
      Hey::ThreadCargo.stub(:sanitize!)
      Hey.sanitize!("ABc1234")
      expect(Hey::ThreadCargo).to have_received(:sanitize!).with("ABc1234")
    end
  end

  describe ".current_actor" do
    it "delegates to the thread cargo class" do
      Hey::ThreadCargo.stub(:current_actor)
      Hey.current_actor
      expect(Hey::ThreadCargo).to have_received(:current_actor)
    end
  end

  describe ".set_current_actor" do
    it "delegates to the thread cargo class" do
      args = { name: "Hello", id: 1234, type: "Employee"}
      Hey::ThreadCargo.stub(:set_current_actor)
      Hey.set_current_actor(args)
      expect(Hey::ThreadCargo).to have_received(:set_current_actor).with(args)
    end
  end

  describe ".configure" do
    it "sets values on the configuration object" do
      Hey.configure do |config|
        config.pubsub_adapter = String
      end
      expect(Hey.configuration.pubsub_adapter).to eq(String)
    end
  end
end
