task :load => :environment do
  require 'active_record/fixtures'
  ActiveRecord::Base.establish_connection(:development)
  Fixtures.create_fixtures('/home/oruki/bb/db', 'med_recs')
end