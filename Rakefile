require 'rubygems'
Gem.clear_paths
Gem.path.unshift(File.join(File.dirname(__FILE__), "gems"))

require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'
require 'spec/rake/spectask'
require 'fileutils'
require 'merb-core'
require 'rubigen'
include FileUtils

# Load the basic runtime dependencies; this will include 
# any plugins and therefore plugin rake tasks.
init_env = ENV['MERB_ENV'] || 'rake'
Merb.load_dependencies(:environment => init_env)

# Get Merb plugins and dependencies
Merb::Plugins.rakefiles.each { |r| require r } 

require 'vlad'
Vlad.load( :app => nil, :scm => 'git' )

desc "start runner environment"
task :merb_env do
  Merb.start_environment(:environment => init_env, :adapter => 'runner')
end

##############################################################################
# SVN
##############################################################################

desc "Add new files to subversion"
task :svn_add do
   system "svn status | grep '^\?' | sed -e 's/? *//' | sed -e 's/ /\ /g' | xargs svn add"
end

# Hack to make the rake tasks for datamapper work
namespace :dm do
  #task :merb_start do
  #  Merb.start :adapter => 'runner',
  #             :environment => ENV['MERB_ENV'] || 'development'
  #
  #  reload_path, pattern = Merb.load_paths[:model]
  #  Dir[ reload_path / pattern ].each do |file|
  #    Merb::BootLoader::LoadClasses.reload( file )
  #  end
  #end

  namespace :db do
    desc "Migrate a single table(s) - pass in TABLE=Model1,Model2 to migrate Model1 and Model2"
    task :migrate => :merb_start do
      for model in ENV['TABLE'].split(',')
        begin
          eval(model).auto_migrate!
          puts "Succesfully migrated model #{model}."
        rescue
          puts "!!! Unable to resolve model name #{model} - did you spell your model name correctly?"
          puts "Auto-migration of #{model} failed."
        end
      end
    end
  end
end