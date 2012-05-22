FactoryGirl.define do

  factory :user do
    sequence(:email) {|n| "email#{n}@factory.com" }
    first_name "Factory"
    last_name "User"
    password "password"
    password_confirmation {|u| u.password }
  end
  
  factory :portfolio do
    name "Freshdirect"
    description "miscellaneous creative files"
  end
end