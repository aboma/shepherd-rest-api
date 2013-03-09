# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
@user = V1::User.create(:email => 'admin@vilio.com', :password => 'letme1nb', :first_name => 'Vilio', 
                          :last_name => 'Admin', :created_by_id => 1, :updated_by_id => 1)
puts "Created seed users" if @user.valid?
puts @user.errors.full_messages.to_sentence unless @user.valid?