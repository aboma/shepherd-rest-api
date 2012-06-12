FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "email#{n}@factory.com" }
    first_name "Factory"
    last_name "User"
    password "password"
    password_confirmation {|u| u.password }
  end
  
  factory :portfolio do
    sequence(:name ){ |n| "Portfolio#{n}" }
    description "factorygirl portfolio"
  end
end