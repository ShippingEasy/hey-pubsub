require "spec_helper"

describe Hey::SanitizedHash do
  after do
    Hey::ThreadCargo.purge!
  end

  let(:values) do
    {
      request: "asdsdads?dasdasads&password=123456",
      response: "password=123456"
    }
  end

  subject { Hey::SanitizedHash.new(values) }

  describe "#to_h" do
    before do
      sanitize_context = Hey::Context.new(sanitize: "123456")
      Hey::ThreadCargo.add_context(sanitize_context)
    end

    it "sanitizes all sanitizable values" do
      expect(subject.to_h[:request]).to eq("asdsdads?dasdasads&password=123456".gsub("123456", ""))
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
        expect(subject.to_h[:http][:request]).to eq("asdsdads?dasdasads&password=123456".gsub("123456", ""))
        expect(subject.to_h[:name]).to eq("Chuck D. ")
      end
    end
  end
end
