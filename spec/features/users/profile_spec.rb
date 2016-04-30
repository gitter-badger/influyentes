describe "Profile", type: :feature do
  let(:user)       { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }

  it "visit my profile" do
    visit "/users/#{user.id}"

    expect(page).to have_content "Profile"
    expect(page).to have_content user.login
  end

  it "visit other user profile" do
    visit "/users/#{other_user.id}"

    expect(page).to have_content "Profile"
    expect(page).to have_content other_user.login
  end
end
