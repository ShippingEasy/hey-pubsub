require 'spec_helper'

describe Hey::Pubsub::Payload do
  before do

  end

  describe "#to_hash" do
    it "adds the current actor" do
      expect(subject.to_hash[:current_actor]).to eq(current_actor)
    end

    it "sanitizes all sanitizable values" do

    end
  end
end
