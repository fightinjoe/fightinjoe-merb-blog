
module DataMapper

# :include:/QUICKLINKS
#
# = Properties
# A model's properties are not derived from database structure.
# Instead, properties are declared inside it's model's class definition,
# which map to (or generate) fields in a database.
# 
# Defining properties explicitly in a model has several advantages.
# It centralizes information about the model
# in a single location, rather than having to dig out migrations, xml,
# or other config files.  It also provides the ability to use Ruby's
# access control functions.  Finally, since Datamapper only cares about
# properties explicitly defined in your models, Datamappers plays well
# with legacy databases and shares databases easily with other
# applications.
#
# == Declaring Properties
# Inside your class, you call the property method for each property you want to add. 
# The only two required arguments are the name and type, everything else is optional.
# 
#   class Post < DataMapper::Base
#     property :title,   :string, :nullable => false # Cannot be null
#     property :publish, :boolen, :default  => false # Default value for new records 
#                                                      is false
#   end
# 
# == Limiting Access
# Property access control is uses the same terminology Ruby does. Properties are 
# public by default, but can also be declared private or protected as needed 
# (via the :accessor option).
# 
#  class Post < DataMapper::Base
#    property :title,  :string, :accessor => :private   # Both reader and writer are private
#    property :body,   :text,   :accessor => :protected # Both reader and writer are protected
#  end
# 
# Access control is also analogous to Ruby getters, setters, and accessors, and can 
# be declared using :reader and :writer, in addition to :accessor.
# 
#  class Post < DataMapper::Base
#    property :title, :string, :writer => :private    # Only writer is private
#    property :tags,  :string, :reader => :protected  # Only reader is protected
#  end
#
# == Overriding Accessors
# The accessor for any property can be overridden in the same manner that Ruby class accessors 
# can be.  After the property is defined, just add your custom accessor:
# 
#  class Post < DataMapper::Base
#    property :title,  :string
#    
#    def title=(new_title)
#      raise ArgumentError if new_title != 'Luke is Awesome'
#      @title = new_title
#    end
#  end
#
# == Lazy Loading
# By default, some properties are not loaded when an object is fetched in Datamapper.  
# These lazily loaded properties are fetched on demand when their accessor is called 
# for the first time (as it is often unnecessary to instantiate -every- property 
# -every- time an object is loaded).  For instance, text fields are lazy loading by 
# default, although you can over-ride this behavior if you wish:
#
# Example:
# 
#  class Post < DataMapper::Base
#    property :title,  :string   # Loads normally
#    property :body,   :text     # Is lazily loaded by default
#  end
# 
# If you want to over-ride the lazy loading on any field you can set it to true or 
# false with the :lazy option.
# 
#  class Post < DataMapper::Base
#    property :title,  :string               # Loads normally
#    property :body,   :text, :lazy => false # The default is now over-ridden
#  end
#
# Delaying the request for lazy-loaded attributes even applies to objects accessed through 
# associations. In a sense, Datamapper anticipates that you will likely be iterating 
# over objects in associations and rolls all of the load commands for lazy-loaded 
# properties into one request from the database.
#
# Example:
#
#   Widget[1].components                    # loads when the post object is pulled from database, by default
#   Widget[1].components.first.body         # loads the values for the body property on all objects in the
#                                             association, rather than just this one.
#                                                    
# == Keys
# Properties can be declared as primary or natural keys on a table.  By default, 
# Datamapper will assume <tt>:id</tt> and create it if you don't have it.  
# You can, however, declare a property as the primary key of the table:
#
#  property :legacy_pk, :string, :key => true
#
# This is roughly equivalent to Activerecord's <tt>set_primary_key</tt>, though 
# non-integer data types may be used, thus Datamapper supports natural keys. 
# When a property is declared as a natural key, accessing the object using the 
# indexer syntax <tt>Class[key]</tt> remains valid.
#
#   User[1] when :id is the primary key on the users table
#   User['bill'] when :name is the primary (natural) key on the users table
#
# == Inferred Validations
# When properties are declared with specific column restrictions, Datamapper 
# will infer a few validation rules for values assigned to that property.
#
#  property :title, :string, :length => 250
#  # => infers 'validates_length_of :title, :minimum => 0, :maximum => 250'
#
#  property :title, :string, :nullable => false
#  # => infers 'validates_presence_of :title
#
#  property :email, :string, :format => :email_address
#  # => infers 'validates_format_of :email, :with => :email_address
#
#  property :title, :string, :length => 255, :nullable => false
#  # => infers both 'validates_length_of' as well as 'validates_presence_of'
#  #    better: property :title, :string, :length => 1..255
#
# For more information about validations, visit the Validatable documentation.
# == Embedded Values
# As an alternative to extraneous has_one relationships, consider using an
# EmbeddedValue.
#
# == Misc. Notes
# * Properties declared as strings will default to a length of 50, rather than 255 
#   (typical max varchar column size).  To overload the default, pass 
#   <tt>:length => 255</tt> or <tt>:length => 0..255</tt>.  Since Datamapper does 
#   not introspect for properties, this means that legacy database tables may need 
#   their <tt>:string</tt> columns defined with a <tt>:length</tt> so that DM does 
#   not inadvertantly truncate data.
# * You may declare a Property with the data-type of <tt>:class</tt>.  
#   see SingleTableInheritance for more on how to use <tt>:class</tt> columns.
  class Property
    
    # NOTE: check is only for psql, so maybe the postgres adapter should define
    # its own property options. currently it will produce a warning tho since
    # PROPERTY_OPTIONS is a constant
    PROPERTY_OPTIONS = [
      :public, :protected, :private, :accessor, :reader, :writer,
      :lazy, :default, :nullable, :key, :serial, :column, :size, :length,
      :format, :index, :check, :ordinal, :auto_validation
    ]
    
    VISIBILITY_OPTIONS = [:public, :protected, :private]
    
    def initialize(klass, name, type, options)
      
      @klass, @name, @type, @options = klass, name.to_sym, type, options
      @symbolized_name = name.to_s.sub(/\?$/, '').to_sym
      
      validate_type!
      validate_options!
      determine_visibility!
      
      database.schema[klass].add_column(@symbolized_name, @type, @options)
      klass::ATTRIBUTES << @symbolized_name
      
      create_getter!
      create_setter!
      auto_validations! unless @options[:auto_validation] == false
      
    end
    
    def validate_type! # :nodoc:
      adapter_class = database.adapter.class
      raise ArgumentError.new("#{@type.inspect} is not a supported type in the database adapter. Valid types are:\n #{adapter_class::TYPES.keys.inspect}") unless adapter_class::TYPES.has_key?(@type)
    end
    
    def validate_options! # :nodoc:
      @options.each_pair do |k,v|
        raise ArgumentError.new("#{k.inspect} is not a supported option in DataMapper::Property::PROPERTY_OPTIONS") unless PROPERTY_OPTIONS.include?(k)
      end
    end
    
    def determine_visibility! # :nodoc:
      @reader_visibility = @options[:reader] || @options[:accessor] || :public
      @writer_visibility = @options[:writer] || @options[:accessor] || :public
      @writer_visibility = :protected if @options[:protected]
      @writer_visibility = :private if @options[:private]
      raise(ArgumentError.new, "property visibility must be :public, :protected, or :private") unless VISIBILITY_OPTIONS.include?(@reader_visibility) && VISIBILITY_OPTIONS.include?(@writer_visibility)
    end
    
    # defines the getter for the property
    def create_getter!
      if lazy?
        klass.class_eval <<-EOS
        #{reader_visibility.to_s}
        def #{name}
          lazy_load!(#{name.inspect})
          class << self;
            attr_accessor #{name.inspect}
          end
          @#{name}
        end
        EOS
      else
        klass.class_eval <<-EOS
        #{reader_visibility.to_s}
        def #{name}
          #{instance_variable_name}
        end
        EOS
      end
      if type == :boolean
        klass.class_eval <<-EOS
        #{reader_visibility.to_s}
        def #{name.to_s.ensure_ends_with('?')}
          #{instance_variable_name}
        end
        EOS
      end
    rescue SyntaxError
      raise SyntaxError.new(column)
    end
    
    # defines the setter for the property
    def create_setter!
      if lazy?
        klass.class_eval <<-EOS
        #{writer_visibility.to_s}
        def #{name}=(value)
          class << self;
            attr_accessor #{name.inspect}
          end
          @#{name} = value
        end
        EOS
      else
        klass.class_eval <<-EOS
        #{writer_visibility.to_s}
        def #{name}=(value)
          #{instance_variable_name} = value
        end
        EOS
      end
    rescue SyntaxError
      raise SyntaxError.new(column)
    end
    
    # NOTE: :length may also be used in place of :size
    AUTO_VALIDATIONS = {
      :nullable => lambda { |k,v| "validates_presence_of :#{k}" if v == false },
      :size => lambda { |k,v| "validates_length_of :#{k}, " + (v.is_a?(Range) ? ":minimum => #{v.first}, :maximum => #{v.last}" : ":maximum => #{v}") },
      :format => lambda { |k, v| "validates_format_of :#{k}, :with => #{v.inspect}" }
    }
    
    AUTO_VALIDATIONS[:length] = AUTO_VALIDATIONS[:size].dup
    
    # defines the inferred validations given a property definition.
    def auto_validations!
      AUTO_VALIDATIONS.each do |key, value|
        next unless options.has_key?(key)
        validation = value.call(name, options[key])
        next if validation.empty?
        klass.class_eval <<-EOS
        begin
          #{validation}
        rescue ArgumentError => e
          throw e unless e.message =~ /specify a unique key/
        end
        EOS
      end
    end
    
    def klass
      @klass
    end
    
    def column
      column = database.table(klass)[@name]
      raise StandardError.new("#{@name.inspect} is not a valid column name") unless column
      return column
    end
     
    def name
      @name
    end
    
    def instance_variable_name # :nodoc:
      column.instance_variable_name
    end
    
    def type
      column.type
    end
    
    def options
      column.options
    end
    
    def reader_visibility # :nodoc:
      @reader_visibility
    end
    
    def writer_visibility # :nodoc:
      @writer_visibility
    end
    
    def lazy?
      column.lazy?
    end
  end
end