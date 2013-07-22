require 'fileutils'

# credit: https://gist.github.com/1332577 wufltone
namespace :db do
  desc 'Drop, create, migrate, and seed a database'
  task :reload => :environment do
    puts "Environment Check: Rails Environment = #{Rails.env}"
    puts "Dropping db"
    Rake::Task['db:drop'].reenable
    Rake::Task['db:drop'].invoke
    puts"Creating db"
    Rake::Task['db:create'].reenable
    Rake::Task['db:create'].invoke
    puts "Migrating db" if Rails.env.development?
    Rake::Task['db:migrate'].reenable if Rails.env.development?
    Rake::Task['db:migrate'].invoke if Rails.env.development?
    puts "Preparing db" if Rails.env.test?
    Rake::Task['db:test:prepare'].reenable if Rails.env.test?
    Rake::Task['db:test:prepare'].invoke if Rails.env.test?
    puts "Seeding db"
    Rake::Task['db:seed'].reenable
    Rake::Task['db:seed'].invoke

    # delete files
    Rake::Task["files:clear"].reenable
    Rake::Task["files:clear"].invoke
  end

  desc 'Drop, create, migrate, and seed development and test databases'
  namespace :reload do
    task :all do
      ['development','test'].each do |env|
        Rails.env = env
        puts "=== Starting #{Rails.env} reload ===\n\n"
        Rake::Task['db:reload'].reenable
        Rake::Task['db:reload'].invoke
        puts "=== Finishing #{Rails.env} reload ===\n\n"
      end
    end
  end

end

# delete uploaded files and their derivatives;
# should only be done when deleting the database
namespace :files do
  desc "Delete asset files directory"
  task :clear => :environment do
    dir = "public/" + V1::AssetUploader::BASE_DIR
    puts "Deleting files directory #{dir}"
    FileUtils.rm_r dir if File.exists?(dir) 
  end
end
