describe "Log in process", type: :feature do
  let(:user) { FactoryGirl.create(:user) }

  it "log me in" do
    visit "/login"

    within("#session") do
      fill_in "Username", with: user.login
      fill_in "Password", with: user.password
    end

    click_button "Log in"
    expect(page).to have_content "You logged out successfully."
  end
end
