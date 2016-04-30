describe "Recover password process", type: :feature do
  let(:user) { FactoryGirl.create(:user) }
  let(:valid_user_attributes) { FactoryGirl.attributes_for(:user) }

  it "request url for reset password" do
    visit "/users/password"

    within("#password") do
      fill_in "Email", with: user.email
    end

    expect do
      click_button "Reset my password"
    end.to change { ActionMailer::Base.deliveries.size }.by(1)

    expect(page).to have_content "Instructions to reset your password have been emailed to you. Please check your email"
  end

  it "reset password using url sent via email" do
    visit "/users/password/reset?token=#{user.perishable_token}"

    within("#password_reset") do
      fill_in "user_password", with: valid_user_attributes[:password] # Password input
      fill_in "Password confirmation", with: valid_user_attributes[:password_confirmation]
    end

    click_button "Update my password and log me in"

    expect(page).to have_content "Password successfully updated"
  end
end
