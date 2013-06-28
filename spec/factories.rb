include ActionDispatch::TestProcess

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

  factory :v1_asset, :class => V1::Asset do
    file { File.open(File.join(Rails.root, 'spec', 'fixtures', 'images', 'test_image.jpeg')) }
    sequence(:name) { |n| "asset test name #{n}" }
    created_by_id 1
    updated_by_id 1
  end

  factory :v1_relationship, :class => V1::Relationship do
    portfolio_id 1
    asset_id 1
    created_by_id 1
    updated_by_id 1
  end

  factory :v1_metadata_field, :class => V1::MetadataField do
    sequence(:name) { |n| "field#{n}" }
    description "test field"
    type "text"
    created_by_id 1
    updated_by_id 1    
  end

  factory :v1_values_list, :class => V1::MetadataValuesList do
    sequence(:name) { |n| "values list#{n}" }
    description "values list"
    created_by_id 1
    updated_by_id 1    
  end

  factory :v1_value, :class => V1::MetadataListValue do
    sequence(:value) { |v| "value#{v}" }
    description "metadata value"
    created_by_id 1
    updated_by_id 1     
  end

  factory :v1_template, :class => V1::MetadataTemplate do
    sequence(:name) { |n| "template#{n}" }
    description "template description"
    created_by_id 1
    updated_by_id 1     
  end

  factory :v1_template_field_setting, :class => V1::MetadataTemplateFieldSetting do
    required true
    order 1
    created_by_id 1
    updated_by_id 1
  end
end
