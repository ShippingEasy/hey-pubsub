require "spec_helper"

describe Hey do
  let(:event_name) { "registration_creation.succeeded" }
  let(:payload) do
    Hey::Pubsub::Event.new(name: "Bing Bong").to_h[:metadata]
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
      expect(Hey.pubsub_adapter).to have_received(:publish!)
    end
  end

  describe ".sanitize!" do
    it "delegates to the thread cargo class" do
      Hey::ThreadCargo.stub(:sanitize!)
      Hey.sanitize!("ABc1234")
      expect(Hey::ThreadCargo).to have_received(:sanitize!).with(["ABc1234"])
    end
  end

  describe ".set" do
    it "delegates to the thread cargo class" do
      Hey::ThreadCargo.stub(:set)
      Hey.set(:name, "Jack Ship")
      expect(Hey::ThreadCargo).to have_received(:set).with(:name, "Jack Ship")
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
