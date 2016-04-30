describe "Sign up process", type: :feature do
  let(:valid_user_attributes) { FactoryGirl.attributes_for(:user) }

  it "sign me up" do
    visit "/signup"

    within("#register") do
      fill_in "Username", with: valid_user_attributes[:login]
      fill_in "Email", with: valid_user_attributes[:email]
      fill_in "user_password", with: valid_user_attributes[:password] # Password input
      fill_in "Password confirmation", with: valid_user_attributes[:password_confirmation]
    end

    click_button "Register"
    expect(page).to have_content "You have signed up successfully."
  end
end
