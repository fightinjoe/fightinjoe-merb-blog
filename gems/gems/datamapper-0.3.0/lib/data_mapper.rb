# This file begins the loading sequence.
#
# Quick Overview:
# * Requires set, fastthread, support libs, and base
# * Sets the applications root and environment for compatibility with rails or merb
# * Checks for the database.yml and loads it if it exists
# * Sets up the database using the config from the yaml file or from the environment
# * 

# This line just let's us require anything in the +lib+ sub-folder
# without specifying a full path.
unless defined?(DM_PLUGINS_ROOT)
  $LOAD_PATH.unshift(File.dirname(__FILE__))

  DM_PLUGINS_ROOT = (File.dirname(__FILE__) + '/../plugins')
end

# Require the basics...
require 'date'
require 'time'
require 'rubygems'
require 'yaml'
require 'set'
require 'fastthread'
require 'validatable'
require 'data_mapper/support/object'
require 'data_mapper/support/blank'
require 'data_mapper/support/enumerable'
require 'data_mapper/support/symbol'
require 'data_mapper/support/string'
require 'data_mapper/support/silence'
require 'data_mapper/support/inflector'
require 'data_mapper/support/errors'
require 'data_mapper/support/typed_set'
require 'data_mapper/database'
require 'data_mapper/persistence'
require 'data_mapper/base'
require 'data_mapper/types/string'


begin
  # This block of code is for compatibility with Ruby On Rails' or Merb's database.yml
  # file, allowing you to simply require the data_mapper.rb in your
  # Rails application's environment.rb to configure the DataMapper.
  unless defined?(DM_APP_ROOT)
    application_root, application_environment = *if defined?(RAILS_ROOT)
      [RAILS_ROOT, RAILS_ENV]
    end
  
    DM_APP_ROOT = application_root || Dir::pwd
  
    if application_root && File.exists?(application_root + '/config/database.yml')

      database_configurations = YAML::load_file(application_root + '/config/database.yml')
      current_database_config = database_configurations[application_environment] || database_configurations[application_environment.to_sym]
    
      config = lambda { |key| current_database_config[key.to_s] || current_database_config[key] }
    
      default_database_config = {
        :adapter  => config[:adapter],
        :host     => config[:host],
        :database => config[:database],
        :username => config[:username],
        :password => config[:password],
        :socket => config[:socket]
      }
  
      DataMapper::Database.setup(default_database_config)
    
    elsif application_root && FileTest.directory?(application_root + '/config')
    
      %w(development testing production).map do |environment|
        <<-EOS.margin
          #{environment}:
            adapter: mysql
            username: root
            password:
            host: localhost
            database: #{File.dirname(DM_APP_ROOT).split('/').last}_#{environment}
        EOS
      end
    
      #File::open(application_root + '/config/database.yml')
    end
  end
rescue Exception
  warn "Could not connect to database specified by database.yml."
end
