include ActionDispatch::TestProcess

## namespace variable
ns = "V1"

FactoryGirl.define do

  factory :v1_user, :class => V1::User do
    sequence(:email) { |n| "email#{n}@factory.com" }
    first_name "Factory"
    last_name "User"
    password "goodpass"
    password_confirmation {|u| u.password }
    created_by_id 1
    updated_by_id 1
  end
  
  factory :v1_portfolio, :class => V1::Portfolio do
    sequence(:name ){ |n| "Portfolio#{n}" }
    created_by_id 1
    updated_by_id 1
    description "factorygirl portfolio"
  end
  
  factory :asset do
    file { File.open(File.join(Rails.root, 'spec', 'fixtures', 'images', 'test_image.jpg')) }
    name { |n| "asset test name #{n}" }
  end

end