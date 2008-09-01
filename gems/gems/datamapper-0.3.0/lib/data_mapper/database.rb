require 'logger'
require 'data_mapper/context'
require 'data_mapper/adapters/abstract_adapter'

# Delegates to DataMapper::database.
# Will not overwrite if a method of the same name is pre-defined.
def database(name = :default, &block)
  DataMapper::database(name, &block)
end unless methods.include?(:database)

module DataMapper
  
  # ===Block Syntax:
  # Pushes the named database onto the context-stack, 
  # yields a new session, and pops the context-stack.
  #
  #   results = DataMapper.database(:second_database) do |current_context|
  #     ...
  #   end
  #
  # ===Non-Block Syntax:
  # Returns the current session, or if there is none,
  # a new Session.
  #
  #   current_database = DataMapper.database
  def self.database(name = :default) # :yields: current_context
    unless block_given?
      Database.context.last || Context.new(Database[name].adapter)
    else
      begin
        Database.context.push(Context.new(Database[name].adapter))
        return yield(Database.context.last)
      ensure
        Database.context.pop
      end
    end
  end
  
  class DatabaseError < StandardError
    attr_accessor :options
  end
  
  # The Database class allows us to setup a default database for use throughout our applications
  # or allows us to setup a collection of databases to use.
  #
  # === Example
  # ==== To setup a default database
  #   DataMapper::Database.setup({
  #    :adapter  => 'mysql'
  #    :host     => 'localhost'
  #    :username => 'root'
  #    :password => 'R00tPaswooooord'
  #    :database => 'selecta_development'
  #   })
  #
  # ==== To setup a named database
  #   DataMapper::Database.setup(:second_database, {
  #    :adapter  => 'postgresql'
  #    :host     => 'localhost'
  #    :username => 'second_user'
  #    :password => 'second_password'
  #    :database => 'second_database'
  #   })
  #
  #
  # ==== Working with multiple databases (see #DataMapper::database)
  #   DataMapper.database(:second_database) do
  #     ...
  #   end
  #
  #   DataMapper.database(:default) do
  #     ...
  #   end
  #
  # or even...
  #
  #   #The below variables still hold on to their database sessions.
  #   #So no confusion happens when passing variables around scopes.
  #
  #   DataMapper.database(:second_database) do
  #
  #     animal = Animal.first
  #
  #     DataMapper.database(:default) do
  #       Animal.new(animal).save
  #     end # :default database
  #
  #   end # :second_database
  class Database
    
    @databases = {}
    
    # Allows you to access any of the named databases you have already setup.
    #
    #   default_db = DataMapper::Database[:default]
    #   second_db = DataMapper::Database[:second_database]
    def self.[](name)
      @databases[name]
    end
    
    # Returns the array of Database sessions currently being used
    #
    # This is what gives us thread safety, boys and girls
    def self.context
      Thread::current[:database_contexts] || Thread::current[:database_contexts] = []
    end
    
    # Setup creates a database and sets all of your properties for that database.
    # Setup looks for either a hash of options passed in to the database or a symbolized name
    # for your database, as well as it's hash of parameters
    #
    # If no options are passed, an ArgumentException will be raised.
    #   
    #   DataMapper::Database.setup(name = :default, options_hash)
    #
    #   DataMapper::Database.setup({
    #    :adapter  => 'mysql'
    #    :host     => 'localhost'
    #    :username => 'root'
    #    :password => 'R00tPaswooooord'
    #    :database => 'selecta_development'
    #   })
    #
    #
    #   DataMapper::Database.setup(:named_database, {
    #    :adapter  => 'mysql'
    #    :host     => 'localhost'
    #    :username => 'root'
    #    :password => 'R00tPaswooooord'
    #    :database => 'selecta_development'
    #   })
    
    def self.setup(*args)
      
      name, options = nil
      
      if (args.nil?) || (args[1].nil? && args[0].class != Hash)
        raise ArgumentError.new('Database cannot be setup without at least an options hash.')
      end
      
      if args.size == 1
        name, options = :default, args[0]
      elsif args.size == 2
        name, options = args[0], args[1]
      end        
      
      current = self.new(name)
      
      current.single_threaded = false if options[:single_threaded] == false
      
      options.each_pair do |k,v|
        current.send("#{k}=", v)
      end
      
      @databases[name] = current
    end
    
    # Creates a new database object with the name you specify, and a default set of options.
    #
    # The default options are as follows:
    #   { :host => 'localhost', :database => nil, :port => nil, :username => 'root', :password => '', :adapter = nil }
    def initialize(name)
      @name = name
      
      @adapter = nil
      @host = 'localhost'
      @database = nil
      @port = nil
      @schema_search_path = nil
      @username = 'root'
      @password = ''
      @socket = nil
      
      @log_level = Logger::WARN
      @log_stream = nil
    end
    
    attr_reader :name, :adapter, :log_stream
    
    attr_accessor :host, :database, :port, :schema_search_path, :username, :password, :log_level, :index_path, :socket
    
    def log_stream=(val)
      @log_stream = (val.is_a?(String) && val =~ /STDOUT/ ? STDOUT : val)
    end
    
    # Allows us to set the adapter for this database object. It can only be set once, and expects two types of values.
    #
    # You may pass in either a class inheriting from DataMapper::Adapters::AbstractAdapter
    # or pass in a string indicating the type of adapter you would like to use.
    #
    # To create your own adapters, create a file in data_mapper/adapters/new_adapter.rb that inherits from AbstractAdapter
    #
    #   database.adapter=("postgresql")
    def adapter=(value)
      if @adapter
        raise ArgumentError.new('The adapter is readonly after being set')
      end
      
      if value.is_a?(DataMapper::Adapters::AbstractAdapter)
        @adapter = value
      elsif value.is_a?(Class)
        @adapter = value.new(self)
      else
        begin
          require "data_mapper/adapters/#{Inflector.underscore(value)}_adapter"
        rescue LoadError
          require "#{Inflector.underscore(value)}_adapter"
        end
        adapter_class = Adapters::const_get(Inflector.classify(value) + "Adapter")
      
        @adapter = adapter_class.new(self)
      end
    end
    
    # Default Logger from Ruby's logger.rb
    def logger
      @logger = create_logger
    
      class << self
        attr_reader :logger
      end
    
      return @logger
    end
    
    def create_logger
      x = Logger.new(@log_stream, File::WRONLY | File::APPEND | File::CREAT)
      x.level = @log_level
      at_exit { x.close }
      return x
    end
  end
  
end