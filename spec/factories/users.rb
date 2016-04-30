FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    login      { "#{first_name}#{Faker::Number.number(3)}" }
    email      { Faker::Internet.safe_email }
    password   { Faker::Internet.password }
    password_confirmation { password }
  end

  factory :invalid_user do
    login nil
    email nil
    password nil
    password_confirmation nil
  end
end
