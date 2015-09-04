require "spec_helper"

describe Hey::SanitizedHash do
  after do
    Hey::ThreadCargo.purge!
  end

  let(:name) { "succeeded" }

  subject { Hey::EventName.new(name) }

  describe "#to_s" do
    context "when a global namespace is set" do
      before do
        Hey.configure do |config|
          config.global_namespace = "yo"
        end
      end

      after do
        Hey.configure do |config|
          config.global_namespace = nil
        end
      end

      it "adds the global namespace to the name" do
        expect(subject.to_s).to eq("yo:#{name}")
      end
    end
    context "when namespaces are set" do
      before do
        context = Hey::Context.new(namespace: "foo")
        Hey::ThreadCargo.add_context(context)
        context = Hey::Context.new(namespace: "bar")
        Hey::ThreadCargo.add_context(context)
      end

      it "adds a namespace to the name" do
        expect(subject.to_s).to eq("foo:bar:#{name}")
      end
    end
  end
end
