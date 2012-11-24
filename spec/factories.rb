FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "email#{n}@factory.com" }
    first_name "Factory"
    last_name "User"
    password "goodpass"
    password_confirmation {|u| u.password }
  end
  
  factory :portfolio do
    sequence(:name ){ |n| "Portfolio#{n}" }
    created_by_id 1
    updated_by_id 1
    description "factorygirl portfolio"
  end

end