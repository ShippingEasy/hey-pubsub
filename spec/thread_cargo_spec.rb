require "spec_helper"

describe Hey::ThreadCargo do
  after do
    Hey::ThreadCargo.purge!
  end

  describe "#get, #set" do
    specify do
      value = "Hello"
      Hey::ThreadCargo.set(:test_value, value)
      expect(Hey::ThreadCargo.get(:test_value)).to eq(value)
    end
  end

  describe "#uuid" do
    context "when uuid is not set" do
      it "creates a new one" do
        expect(Hey::ThreadCargo.uuid).to_not be_nil
        expect(Hey::ThreadCargo.get(:uuid)).to_not be_nil
      end
    end
  end

  describe "#to_hash" do
    it "does not return the santizable values" do
      expect(Hey::ThreadCargo.to_hash[Hey::ThreadCargo::SANITIZABLE_VALUES_KEY]).to be_nil
    end

    it "returns a hash of values" do
      Hey::ThreadCargo.set(:test, "test")
      expect(Hey::ThreadCargo.to_hash[:test]).to eq("test")
    end
  end

  describe "#purge!" do
    before do
      Hey::ThreadCargo.set(:name, "Jim Jones")
      Hey::ThreadCargo.sanitize!("test")
      Hey::ThreadCargo.purge!
    end

    it "unsets the current actor" do
      expect(Hey::ThreadCargo.get(:name)).to be_nil
    end

    it "unsets the sanitizable values" do
      expect(Hey::ThreadCargo.sanitizable_values).to be_empty
    end
  end

  describe "#sanitize!, #sanitizable_values" do
    before do
      Hey::ThreadCargo.sanitize!(value)
    end

    context "when a string" do
      let(:value) { "test" }

      specify do
        expect(Hey::ThreadCargo.sanitizable_values).to eq([value])
      end
    end

    context "when a an array" do
      let(:value) { ["test", "Something", "new"] }

      specify do
        expect(Hey::ThreadCargo.sanitizable_values).to eq(value)
      end
    end

    context "when a an array and adding to existing values" do
      let(:value) { ["test", "Something", "new"] }
      let(:value2) { ["test2", "Something2", "new2"] }

      before do
        Hey::ThreadCargo.sanitize!(value2)
      end

      specify do
        expect(Hey::ThreadCargo.sanitizable_values).to eq((value + value2).flatten)
      end
    end

    context "when a string and adding to existing values" do
      let(:value) { "Hello" }
      let(:value2) { "Hello2" }
      before do
        Hey::ThreadCargo.sanitize!(value2)
      end

      specify do
        expect(Hey::ThreadCargo.sanitizable_values).to eq([value, value2])
      end
    end

    context "when adding duplicate values" do
      let(:value) { "Hello" }
      let(:value2) { "Hello" }
      before do
        Hey::ThreadCargo.sanitize!(value2)
      end

      specify do
        expect(Hey::ThreadCargo.sanitizable_values).to eq([value])
      end
    end
  end
end
