# = DataMapper Reflections
#
# This adds support for reflections to DataMapper.  Reflections are a way of
# type-casting attribute values to match the column types of the database.
#
# This solution isn't fully automated; ideally DataMapper would look at the type
# of a column and decide whether or not a reflection is necessary.
#
# ActiveRecord uses reflections in practice to handle multi-param attributes
# such as Date and DateTime.  In this way, the following works:
#
# == ActiveRecord example
#   User.create( 'birthday(1i)' => 1979, 'birthday(2i)' => 8, 'birthday(3i)' => 23 )
#   # => <User: birthday => '1979-08-23'>
#
# == Usage
# Reflections must be specified manually on DataMapper properties with the
# :reflect option.  This option takes either a symbol refrencing an instance method
# or an anonymous function.  The :reflect method is then run whenever
# the attribute_writer is called (this includes calls to #new and #create and 
# #update_attributes).
#
# == Example
#   require 'datamapper_reflection'
#   class Blog < DataMapper::Base
#     include DataMapper::Reflection
#     # property :birthday, :date, :reflect => lambda { |b| Date.parse('%4d.%2d.%2d' % [b[:year],b[:month],b[:year]]) }
#     property :birthday, :date, :reflect => :parse_date
#
#     private
#
#     def parse_date( b )
#       Date.parse('%4d.%2d.%2d' % [b[:year],b[:month],b[:year]])
#     end
#   end
#
#
module DataMapper
  class Property
    self.const_get('PROPERTY_OPTIONS') << :reflect

    def create_setter!
      if lazy?
        klass.class_eval <<-EOS
        #{writer_visibility.to_s}
        def #{name}=(value)
          class << self;
            attr_accessor #{name.inspect}
          end
          @#{name} = reflect_or_return(#{name.inspect},value)
        end
        EOS
      else
        klass.class_eval <<-EOS
        #{writer_visibility.to_s}
        def #{name}=(value)
          #{instance_variable_name} = reflect_or_return(#{name.inspect},value)
        end
        EOS
      end
    rescue SyntaxError
      raise SyntaxError.new(column)
    end
  end

  module Reflection
    private
      # Given the +name+ of a property, will find the corresponding DataMapper::Property instance
      def property_for( name )
        properties = self.class.properties
        property   = properties.select { |property| property.name.to_s == name.to_s }
        property.first
      end

      # Given the +name+ of a property, will find the corresponding reflection method
      # if one was set.  Otherwise will return nil.
      def reflect_proc(name)
        method = property_for(name).options[:reflect]
        out = case method
        when nil, Proc then method # do nothing
        when Symbol                # lookup the function and wrap in an anonymous function that takes the value as a parameter
          lambda { |value| puts [method,value].inspect; send( method, value ) }
        else raise ArgumentError.new("#{method.inspect} is not an anonymous function or a symbol pointing to an instance method")
        end
        out
      end

      # Runs the reflection for the property +name+ against the +value+.  Returns +value+
      # if there is no corresponding reflection
      def reflect_or_return( name, value )
        method = reflect_proc(name)
        return value unless method.is_a?( Proc )
        method.call( value )
      end
  end
  
end