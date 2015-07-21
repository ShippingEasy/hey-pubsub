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

  describe "#to_h" do
    before do
      Hey::ThreadCargo.set(:current_actor, current_actor)
      Hey::ThreadCargo.sanitize!("123456")
    end

    it "adds the current actor" do
      expect(subject.to_h[:metadata][:current_actor]).to eq(current_actor)
    end

    it "sets the name" do
      expect(subject.to_h[:name]).to eq("pubsub.#{name}")
    end

    it "adds the uuid" do
      expect(subject.to_h[:uuid]).to eq(Hey::ThreadCargo.uuid)
    end

    it "sanitizes all sanitizable values" do
      expect(subject.to_h[:metadata][:request]).to eq("asdsdads?dasdasads&password=123456".gsub("123456", ""))
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
    end
  end
end
