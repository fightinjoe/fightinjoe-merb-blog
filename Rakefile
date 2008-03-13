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

require 'vlad'
Vlad.load( :app => nil, :scm => 'git' )

$RAKE_ENV = true

init_file = File.join(File.dirname(__FILE__) / "config" / "init")

Merb.load_dependencies(init_file)
           
include FileUtils
# # # Get Merb plugins and dependencies
Merb::Plugins.rakefiles.each {|r| require r } 

# 
#desc "Packages up Merb."
#task :default => [:package]

desc "load merb_init.rb"
task :merb_init do
  require 'merb-core'
  require File.dirname(__FILE__)+'/config/init.rb'
end  

task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{NAME}}
end

desc 'Run all tests, specs and finish with rcov'
task :aok do
  sh %{rake rcov}
  sh %{rake spec}
end

unless Gem.cache.search("haml").empty?
  namespace :haml do
    desc "Compiles all sass files into CSS"
    task :compile_sass do
      gem 'haml'
      require 'sass'
      puts "*** Updating stylesheets"
      Sass::Plugin.update_stylesheets
      puts "*** Done"      
    end
  end
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