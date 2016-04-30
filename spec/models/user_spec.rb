describe User, type: :model do
  let(:user) { FactoryGirl.create(:user) }

  it "has gravatar_url" do
    expect(user.gravatar_url).to match(/http(|s):\/\/secure\.gravatar\.com\/avatar\/([a-zA-Z0-9]+)\.png/)
  end
end
