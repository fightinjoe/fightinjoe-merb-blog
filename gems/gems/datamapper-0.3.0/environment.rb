unless defined?(INITIAL_CLASSES)
  # Require the DataMapper, and a Mock Adapter.
  require File.dirname(__FILE__) + '/lib/data_mapper'
  require File.dirname(__FILE__) + '/spec/mock_adapter'

  adapter = ENV['ADAPTER'] || 'sqlite3'

  configuration_options = {
    :adapter => adapter,
    :database =>  (ENV['DATABASE'] || 'data_mapper_1').dup
  }

  # Prepare the log path, and remove the existing spec.log
  require 'fileutils'

  if ENV['LOG_NAME']
    log_path = nil
    
    if ENV['LOG_NAME'] != 'STDOUT'
      FileUtils::mkdir_p(File.dirname(__FILE__) + '/log')
      log_path = File.dirname(__FILE__) + "/log/#{ENV['LOG_NAME']}.log"
      FileUtils::rm log_path if File.exists?(log_path)
    else
      log_path = 'STDOUT'
    end
    
    configuration_options.merge!(:log_stream => log_path, :log_level => Logger::DEBUG)
  end

  case adapter
    when 'postgresql' then
      configuration_options[:username] = ENV['USERNAME'] || 'postgres'
    when 'mysql' then
      configuration_options[:username] = 'root'
    when 'sqlite3' then
      unless configuration_options[:database] == ':memory:'
        configuration_options[:database] << '.db'
      end
  end

  load_models = lambda do
    Dir[File.dirname(__FILE__) + '/spec/models/*.rb'].sort.each { |path| load path }
  end

  secondary_configuration_options = configuration_options.dup
  secondary_configuration_options.merge!(:database => (adapter == 'sqlite3' ? 'data_mapper_2.db' : 'data_mapper_2'))
  
  DataMapper::Database.setup(configuration_options)
  DataMapper::Database.setup(:secondary, secondary_configuration_options)
  DataMapper::Database.setup(:mock, :adapter => MockAdapter)

  [:default, :secondary, :mock].each { |name| database(name) { load_models.call } }

  # Reset the test database.
  unless ENV['AUTO_MIGRATE'] == 'false'
    [:default, :secondary].each { |name| database(name) { DataMapper::Persistence.auto_migrate! } }
  end

  # Save the initial database layout so we can put everything back together
  # after auto migrations testing
  INITIAL_CLASSES = Array.new(DataMapper::Persistence.subclasses.to_a)
end