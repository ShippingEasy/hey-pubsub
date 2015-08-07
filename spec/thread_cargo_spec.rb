require "spec_helper"

describe Hey::ThreadCargo do
  after do
    Hey::ThreadCargo.purge!
  end

  describe ".uuid" do
    context "when uuid is not set" do
      it "creates a new one" do
        expect(Hey::ThreadCargo.uuid).to_not be_nil
        expect(Thread.current[:hey][:uuid]).to_not be_nil
      end
    end
  end

  describe ".purge!" do
    before do
      Hey::ThreadCargo.uuid
      Hey::ThreadCargo.purge!
    end

    it "unsets the whole namespace" do
      expect(Thread.current[:hey]).to be_nil
    end
  end

  describe ".add_contexts" do
    it "adds a context to the array" do
      context = Hey::Context.new(foo: "bar")
      Hey::ThreadCargo.add_context(context)
      expect(Hey::ThreadCargo.contexts).to include(context)
    end
  end

  describe ".remove_contexts" do
    it "removes a context from the array" do
      context = Hey::Context.new(foo: "bar")
      Hey::ThreadCargo.init!
      Thread.current[:hey][:contexts] = [context]
      Hey::ThreadCargo.remove_context(context)
      expect(Hey::ThreadCargo.contexts).to be_empty
    end
  end

  describe ".contexts" do
    context "when no contexts have been added" do
      it "returns an empty array" do
        expect(Hey::ThreadCargo.contexts).to be_empty
      end
    end

    context "when contexts have been added" do
      it "returns an array of contexts" do
        context = Hey::Context.new(foo: "bar")
        Hey::ThreadCargo.add_context(context)
        expect(Hey::ThreadCargo.contexts).to eq([context])
      end
    end
  end
end
