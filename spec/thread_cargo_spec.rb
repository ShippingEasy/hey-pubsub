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

  describe "#current_actor, #set_current_actor" do
    specify do
      Hey::ThreadCargo.set_current_actor(id: 1234, name: "Jim Jones", type: "employee")
      expect(Hey::ThreadCargo.current_actor).to eq({id: 1234, name: "Jim Jones", type: "employee"})
    end
  end

  describe "#purge!" do
    before do
      Hey::ThreadCargo.set_current_actor(id: 1234, name: "Jim Jones", type: "employee")
      Hey::ThreadCargo.sanitize!("test")
      Hey::ThreadCargo.purge!
    end

    it "unsets the current actor" do
      expect(Hey::ThreadCargo.current_actor).to be_nil
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
