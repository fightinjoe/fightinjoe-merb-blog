$TESTING=true
require 'rubygems'
require 'merb-core'
require 'ruby-debug'

# TODO: Boot Merb, via the Test Rack adapter
Merb.start :environment => (ENV['MERB_ENV'] || 'test'),
           :adapter     => 'runner',
           :merb_root  => File.join(File.dirname(__FILE__), ".." )


Spec::Runner.configure do |config|
  config.include(Merb::Test::Helpers)
  config.include(Merb::Test::RequestHelper)
end

DataMapper::Base.auto_migrate!

module Spec
  module Matchers
    # http://www.last100meters.com/2007/12/11/a-handy-assert_difference-for-rspec
    class BeDifferentBy
      
      attr_reader :difference, :lamb, :target, :initial, :after
      
      def initialize(difference, b)
        @difference, @lamb = difference, b
      end
      
      def matches?(target)
        @target = target
        @initial = target.call
        @lamb.call
        @after = target.call
        (@initial + @difference) == @after
      end
      
      def failure_message
        "expected initial value of <#{@initial}> to be <#{(@initial + @difference)}> but was <#{@after}>"
      end
      
      def negative_failure_message
        "expected initial value of <#{@initial}> NOT to be <#{(@initial + @difference)}> but was <#{@after}>"
      end
    end
    
    def be_different_by(difference, &b)
      BeDifferentBy.new(difference, b)
    end
  end
  
  
end