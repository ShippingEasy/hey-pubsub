require 'spec_helper'

describe Hey::Pubsub::Payload do
  after do
    Hey::ThreadCargo.purge!
  end

  let(:current_actor) do
    {
      name: "Jack Ship",
      id: "1234",
      type: "Employee"
    }
  end

  let(:values) do
    {
      request: "asdsdads?dasdasads&password=123456",
      response: "password=123456"
    }
  end

  subject { Hey::Pubsub::Payload.new(values) }

  describe "#to_hash" do
    before do
      Hey::ThreadCargo.set_current_actor(current_actor)
      Hey::ThreadCargo.sanitize!("123456")
    end

    it "adds the current actor" do
      expect(subject.to_hash[:current_actor]).to eq(current_actor)
    end

    it "sanitizes all sanitizable values" do
      expect(subject.to_hash[:request]).to eq("asdsdads?dasdasads&password=123456".gsub("123456", ""))
    end

    context "with a set of nested hashes" do
      let(:values) do
        {
          http: {
            request: "asdsdads?dasdasads&password=123456"
          },
          name: "Chuck D. 123456"
        }
      end

      it "sanitizes all sanitizable values" do
        expect(subject.to_hash[:http][:request]).to eq("asdsdads?dasdasads&password=123456".gsub("123456", ""))
        expect(subject.to_hash[:name]).to eq("Chuck D. ")
      end
    end

    it "returns the hash" do
      hash = {:request=>"asdsdads?dasdasads&password=", :response=>"password=", :current_actor=>{:name=>"Jack Ship", :type=>"Employee", :id=>"1234"}}
      expect(subject.to_hash).to eq(hash)
    end
  end
end
