require 'data_mapper/persistence'
require 'data_mapper/is/tree'

module DataMapper

  class Base
		include DataMapper::Is::Tree
    
    def self.inherited(klass)
      klass.send(:include, DataMapper::Persistence)
    end

    def self.auto_migrate!
      DataMapper::Persistence.auto_migrate!
    end
  end
end
