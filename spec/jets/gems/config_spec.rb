RSpec.describe Jets::Gems::Config do
  let(:config) { described_class.instance }

  context "data" do
    it "load config" do
      expect(config.data).to eq({"key" => "fakekey-in-home"})
    end
  end
end
