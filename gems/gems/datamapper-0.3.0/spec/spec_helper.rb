require 'pp'

ENV['LOG_NAME'] = 'spec'
require File.dirname(__FILE__) + '/../environment'

# Define a fixtures helper method to load up our test data.
def fixtures(name)
  entry = YAML::load_file(File.dirname(__FILE__) + "/fixtures/#{name}.yaml")
  klass = begin
    Kernel::const_get(Inflector.classify(Inflector.singularize(name)))
  rescue
    nil
  end

  unless klass.nil?
    database.logger.debug { "AUTOMIGRATE: #{klass}" }
    klass.auto_migrate!

    (entry.kind_of?(Array) ? entry : [entry]).each do |hash|
      if hash['type']
        Object::const_get(hash['type'])::create(hash)
      else
        klass::create(hash)
      end
    end
  else
    table = database.table(name.to_s)
    table.create! true
    table.activate_associations!

    #pp database.schema

    (entry.kind_of?(Array) ? entry : [entry]).each do |hash|
      table.insert(hash)
    end
  end
end

def load_database
  Dir[File.dirname(__FILE__) + "/fixtures/*.yaml"].each do |path|
    fixtures(File::basename(path).sub(/\.yaml$/, ''))
  end
end

load_database
