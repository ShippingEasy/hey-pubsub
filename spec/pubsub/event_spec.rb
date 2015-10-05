require "spec_helper"

describe Hey::Pubsub::Event do
  after do
    Hey::ThreadCargo.purge!
  end

  let(:name) { "registration.completed" }

  let(:current_actor) do
    {
      name: "Jack Ship",
      id: "1234",
      type: "Employee"
    }
  end

  let(:metadata) do
    {
      request: "asdsdads?dasdasads&password=123456",
      response: "password=123456"
    }
  end

  let(:ended_at) { Time.now }
  let(:started_at) { ended_at - 1000 }

  subject { Hey::Pubsub::Event.new(name: name, metadata: metadata, started_at: started_at, ended_at: ended_at) }

  describe "#metadata" do
    before do
      context = Hey::Context.new(current_actor: current_actor)
      Hey::ThreadCargo.add_context(context)
      sanitize_context = Hey::Context.new(sanitize: "123456")
      Hey::ThreadCargo.add_context(sanitize_context)
    end

    it "sanitizes all sanitizable values" do
      expect(subject.to_h[:metadata][:request]).to eq("asdsdads?dasdasads&password=123456".gsub("123456", ""))
    end

    it "removes the sanitize entry" do
      expect(subject.to_h[:metadata][:sanitize]).to be_nil
    end

    context "with a set of nested hashes" do
      let(:metadata) do
        {
          http: {
            request: "asdsdads?dasdasads&password=123456"
          },
          name: "Chuck D. 123456"
        }
      end

      it "sanitizes all sanitizable values" do
        expect(subject.to_h[:metadata][:http][:request]).to eq("asdsdads?dasdasads&password=123456".gsub("123456", ""))
        expect(subject.to_h[:metadata][:name]).to eq("Chuck D. ")
      end

      it "adds the context metadata" do
        expect(subject.to_h[:metadata][:current_actor]).to eq(current_actor)
      end
    end
  end

  describe "#duration" do
    context "when started at is nil" do
      it "doesn't attempt to calculate it" do
        subject.started_at = nil
        expect(subject.duration).to be_nil
      end
    end

    context "when ended at is nil" do
      it "doesn't attempt to calculate it" do
        subject.ended_at = nil
        expect(subject.duration).to be_nil
      end
    end

    it "calculates it" do
      time_as_int = 1438877184
      subject.started_at = Time.at(time_as_int)
      subject.ended_at = Time.at(time_as_int + 10)
      expect(subject.duration).to eq(10000.0)
    end
  end

  describe "#started_at" do
    it "formats it into a string" do
      subject.started_at = Date.parse("2015-07-07")
      expect(subject.started_at).to eq("2015-07-07T00:00:00.000")
    end

    context "when nil" do
      it "doesn't attempt to format it" do
        subject.started_at = nil
        expect(subject.started_at).to be_nil
      end
    end
  end

  describe "#ended_at" do
    it "formats it into a string" do
      subject.ended_at = Date.parse("2015-07-07")
      expect(subject.ended_at).to eq("2015-07-07T00:00:00.000")
    end

    context "when nil" do
      it "doesn't attempt to format it" do
        subject.ended_at = nil
        expect(subject.ended_at).to be_nil
      end
    end
  end

  describe "#to_h" do
    it "sets the name" do
      expect(subject.to_h[:name]).to eq(name)
    end

    it "adds the uuid" do
      expect(subject.to_h[:uuid]).to eq(Hey::ThreadCargo.uuid)
    end

    it "sets the duration" do
      expect(subject.to_h[:duration]).to_not be_nil
    end

    it "sets started at" do
      expect(subject.to_h[:started_at]).to_not be_nil
    end

    it "sets ended at" do
      expect(subject.to_h[:ended_at]).to_not be_nil
    end

    it "sets metadata" do
      expect(subject.to_h[:metadata]).to_not be_nil
    end
  end
end
