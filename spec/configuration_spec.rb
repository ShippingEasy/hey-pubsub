require 'spec_helper'

describe Hey::Configuration do

  subject { Hey::Configuration.new }

  describe "#pubsub_adapter" do
    it "defaults to the ASN adapter" do
      expect(subject.pubsub_adapter).to eq(Hey::Pubsub::Adapters::AsnAdapter)
    end
  end

  describe "#pubsub_adapter=" do
    specify do
      subject.pubsub_adapter = String
      expect(subject.pubsub_adapter).to eq(String)
    end
  end
end
