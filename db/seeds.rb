# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(:email => 'aboma@grey.com', :password => 'letme1n', :first_name => 'Adrian', :last_name => 'Boma')
User.create(:email => 'dvark@grey.com', :password => 'letme1n', :first_name => 'Diana', :last_name => 'Vark')
puts "Created seed users"
