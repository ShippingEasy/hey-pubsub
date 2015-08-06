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

  describe ".context" do
    it "adds the context to thread cargo" do
      Hey.context(foo: "bar") do
        expect(Hey::ThreadCargo.contexts.first[:foo]).to eq("bar")
      end
    end

    it "cleans up the context" do
      Hey.context(foo: "bar") do
        nil
      end
      expect(Hey::ThreadCargo.contexts).to be_empty
    end

    it "purges the namespace" do
      Hey.context(foo: "bar") do
        nil
      end
      expect(Thread.current[:hey]).to be_nil
    end

    context "when contexts nested" do
      it "adds the inner context" do
        Hey.context(foo: "bar") do
          Hey.context(bar: "foo") do
            expect(Hey::ThreadCargo.contexts.count).to eq(2)
          end
        end
      end

      it "cleans up the inner context" do
        Hey.context(foo: "bar") do
          Hey.context(bar: "foo") do
            nil
          end
          expect(Hey::ThreadCargo.contexts.count).to eq(1)
        end
      end
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
