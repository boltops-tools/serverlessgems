RSpec.describe Jets::Gems::Config::Token do
  let(:main) { described_class.new }

  it "load config.yml data" do
    root, ENV['JETS_ROOT'] = ENV['JETS_ROOT'], '/fake'
    expect(main.key).to eq "fakekey-in-home"
    ENV['JETS_ROOT'] = root
  end
end
