
require 'active_record'


namespace :db do

    task :connect => 'config/database.yml' do |t|
      ActiveRecord::Base.establish_connection \
        YAML.load_file 'config/database.yml'
    end
  
    task :disconnect do
      ActiveRecord::Base.clear_all_connections!
    end
  
    desc 'Create the  database'
    task :create do
      sh 'createdb zerodown'
    end
  
    desc 'Drop the  database'
    task :drop => :disconnect do
      sh 'dropdb zerodown'
    end
  
    namespace :migrate do
  
      desc 'Run the  database migrations'
      task :up => :'db:connect' do
        migrations = if ActiveRecord.version.version >= '5.2'
          ActiveRecord::Migration.new.migration_context.migrations
        else
          ActiveRecord::Migrator.migrations('db/migrate')
        end
        ActiveRecord::Migrator.new(:up, migrations, nil).migrate
      end
  
      desc 'Reverse the  database migrations'
      task :down => :'db:connect' do
        migrations = if ActiveRecord.version.version >= '5.2'
          ActiveRecord::Migration.new.migration_context.migrations
        else
          ActiveRecord::Migrator.migrations('db/migrate')
        end
        ActiveRecord::Migrator.new(:down, migrations, nil).migrate
      end
    end
    task :migrate => :'migrate:up'
  
    desc 'Create and configure the  database'
    task :setup => [ :create, :migrate ]
  
    desc 'Drop the  tables and database'
    task :teardown => [ :'migrate:down', :drop ]
  end