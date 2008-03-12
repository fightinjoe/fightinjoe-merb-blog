$TESTING=true
require 'rubygems'
require 'merb-core'
require 'ruby-debug'
require 'spec'

Merb.start :environment => (ENV['MERB_ENV'] || 'test'),
           :merb_root  => File.join(File.dirname(__FILE__), ".." )

class Merb::Mailer
  self.delivery_method = :test_send
end

Spec::Runner.configure do |config|
  config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::ControllerHelper)
#  config.mock_with :mocha
end

# DataMapper::Persistence.auto_migrate!

# http://www.last100meters.com/2007/12/11/a-handy-assert_difference-for-rspec
# ==== Example
#   lambda { User.count }.should be_different_by(1) { User.create }
module Spec
  module Matchers
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