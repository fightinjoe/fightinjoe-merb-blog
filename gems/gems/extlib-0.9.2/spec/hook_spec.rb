require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe Extlib::Hook do

  before(:each) do
    @module = Module.new do
      def greet; greetings_from_module; end;
    end

    @class = Class.new do
      include Extlib::Hook

      def hookable; end;
      def self.clakable; end;
      def ambiguous; hi_mom!; end;
      def self.ambiguous; hi_dad!; end;
    end

    @another_class = Class.new do
      include Extlib::Hook
    end

    @other = Class.new do
      include Extlib::Hook

      def hookable; end
      def self.clakable; end;
    end

    @class.register_instance_hooks :hookable
    @class.register_class_hooks :clakable
  end

  #
  # Specs out how hookable methods are registered
  #
  describe "explicit hookable method registration" do

    describe "for class methods" do

      it "shouldn't confuse instance method hooks and class method hooks" do
        @class.register_instance_hooks :ambiguous
        @class.register_class_hooks :ambiguous

        @class.should_receive(:hi_dad!)
        @class.ambiguous
      end

      it "should be able to register multiple hookable methods at once" do
        %w(method_one method_two method_three).each do |method|
          @another_class.class_eval %(def self.#{method}; end;)
        end

        @another_class.register_class_hooks :method_one, :method_two, :method_three
        @another_class.class_hooks.keys.should include(:method_one)
        @another_class.class_hooks.keys.should include(:method_two)
        @another_class.class_hooks.keys.should include(:method_three)
      end

      it "should not allow a method that does not exist to be registered as hookable" do
        lambda { @another_class.register_class_hooks :method_one }.should raise_error(ArgumentError)
      end

      it "should allow hooks to be registered on methods from module extensions" do
        @class.extend(@module)
        @class.register_class_hooks :greet
        @class.class_hooks[:greet].should_not be_nil
      end

      it "should allow modules to register hooks in the self.extended method" do
        @module.class_eval do
          def self.extended(base)
            base.register_class_hooks :greet
          end
        end
        @class.extend(@module)
        @class.class_hooks[:greet].should_not be_nil
      end

      it "should be able to register protected methods as hooks" do
        @class.class_eval %{protected; def self.protected_hookable; end;}
        lambda { @class.register_class_hooks(:protected_hookable) }.should_not raise_error(ArgumentError)
      end

      it "should not be able to register private methods as hooks" do
        @class.class_eval %{class << self; private; def private_hookable; end; end;}
        lambda { @class.register_class_hooks(:private_hookable) }.should raise_error(ArgumentError)
      end

      it "should allow advising methods ending in ? or !" do
        @class.class_eval do
          def self.hookable!; two!; end;
          def self.hookable?; three!; end;
          register_class_hooks :hookable!, :hookable?
        end
        @class.before_class_method(:hookable!) { one! }
        @class.after_class_method(:hookable?) { four! }

         @class.should_receive(:one!).once.ordered
         @class.should_receive(:two!).once.ordered
         @class.should_receive(:three!).once.ordered
         @class.should_receive(:four!).once.ordered

         @class.hookable!
         @class.hookable?
      end

      it "should allow hooking methods ending in ?, ! or = with method hooks" do
        @class.class_eval do
          def self.before_hookable!; one!; end;
          def self.hookable!; two!; end;
          def self.hookable?; three!; end;
          def self.after_hookable?; four!; end;
          register_class_hooks :hookable!, :hookable?
        end
        @class.before_class_method(:hookable!, :before_hookable!)
        @class.after_class_method(:hookable?, :after_hookable?)

         @class.should_receive(:one!).once.ordered
         @class.should_receive(:two!).once.ordered
         @class.should_receive(:three!).once.ordered
         @class.should_receive(:four!).once.ordered

         @class.hookable!
         @class.hookable?
      end
    end

    describe "for instance methods" do

      it "shouldn't confuse instance method hooks and class method hooks" do
        @class.register_instance_hooks :ambiguous
        @class.register_class_hooks :ambiguous

        inst = @class.new
        inst.should_receive(:hi_mom!)
        inst.ambiguous
      end

      it "should be able to register multiple hookable methods at once" do
        %w(method_one method_two method_three).each do |method|
          @another_class.send(:define_method, method) {}
        end

        @another_class.register_instance_hooks :method_one, :method_two, :method_three
        @another_class.instance_hooks.keys.should include(:method_one)
        @another_class.instance_hooks.keys.should include(:method_two)
        @another_class.instance_hooks.keys.should include(:method_three)
      end

      it "should not allow a method that does not exist to be registered as hookable" do
        lambda { @another_class.register_instance_hooks :method_one }.should raise_error(ArgumentError)
      end

      it "should allow hooks to be registered on included module methods" do
        @class.send(:include, @module)
        @class.register_instance_hooks :greet
        @class.instance_hooks[:greet].should_not be_nil
      end

      it "should allow modules to register hooks in the self.included method" do
        @module.class_eval do
          def self.included(base)
            base.register_instance_hooks :greet
          end
        end
        @class.send(:include, @module)
        @class.instance_hooks[:greet].should_not be_nil
      end

      it "should be able to register protected methods as hooks" do
        @class.class_eval %{protected; def protected_hookable; end;}
        lambda { @class.register_instance_hooks(:protected_hookable) }.should_not raise_error(ArgumentError)
      end

      it "should not be able to register private methods as hooks" do
        @class.class_eval %{private; def private_hookable; end;}
        lambda { @class.register_instance_hooks(:private_hookable) }.should raise_error(ArgumentError)
      end

      it "should allow hooking methods ending in ? or ! with block hooks" do
        @class.class_eval do
          def hookable!; two!; end;
          def hookable?; three!; end;
          register_instance_hooks :hookable!, :hookable?
        end
        @class.before(:hookable!) { one! }
        @class.after(:hookable?) { four! }

        inst = @class.new
        inst.should_receive(:one!).once.ordered
        inst.should_receive(:two!).once.ordered
        inst.should_receive(:three!).once.ordered
        inst.should_receive(:four!).once.ordered

        inst.hookable!
        inst.hookable?
      end

      it "should allow hooking methods ending in ?, ! or = with method hooks" do
        @class.class_eval do
          def before_hookable(val); one!; end;
          def hookable=(val); two!; end;
          def hookable?; three!; end;
          def after_hookable?; four!; end;
          register_instance_hooks :hookable=, :hookable?
        end
        @class.before(:hookable=, :before_hookable)
        @class.after(:hookable?, :after_hookable?)

        inst = @class.new
        inst.should_receive(:one!).once.ordered
        inst.should_receive(:two!).once.ordered
        inst.should_receive(:three!).once.ordered
        inst.should_receive(:four!).once.ordered

        inst.hookable = 'hello'
        inst.hookable?
      end
    end

  end

  describe "implicit hookable method registration" do

    describe "for class methods" do
      it "should implicitly register the method as hookable" do
        @class.class_eval %{def self.implicit_hook; end;}
        @class.before_class_method(:implicit_hook) { hello }

        @class.should_receive(:hello)
        @class.implicit_hook
      end
    end

    describe "for instance methods" do
      it "should implicitly register the method as hookable" do
        @class.class_eval %{def implicit_hook; end;}
        @class.before(:implicit_hook) { hello }

        inst = @class.new
        inst.should_receive(:hello)
        inst.implicit_hook
      end

      it 'should not overwrite methods included by modules after the hook is declared' do
        my_module = Module.new do
          # Just another module
          @another_module = Module.new do
            def some_method; "Hello " + super; end;
          end

          def some_method; "world"; end;

          def self.included(base)
            base.before(:some_method, :a_method)
            base.send(:include, @another_module)
          end
        end

        @class.class_eval { include my_module }

        inst = @class.new
        inst.should_receive(:a_method)
        inst.some_method.should == "Hello world"
      end
    end

  end

  describe "hook method registration" do

    describe "for class methods" do
      it "should complain when only one argument is passed" do
        lambda { @class.before_class_method(:clakable) }.should raise_error(ArgumentError)
        lambda { @class.after_class_method(:clakable) }.should raise_error(ArgumentError)
      end

      it "should complain when target_method is not a symbol" do
        lambda { @class.before_class_method("clakable", :ambiguous) }.should raise_error(ArgumentError)
        lambda { @class.after_class_method("clakable", :ambiguous) }.should raise_error(ArgumentError)
      end

      it "should complain when method_sym is not a symbol" do
        lambda { @class.before_class_method(:clakable, "ambiguous") }.should raise_error(ArgumentError)
        lambda { @class.after_class_method(:clakable, "ambiguous") }.should raise_error(ArgumentError)
      end

      it "should not allow methods ending in = to be hooks" do
        lambda { @class.before_class_method(:clakable, :annoying=) }.should raise_error(ArgumentError)
        lambda { @class.after_class_method(:clakable, :annoying=) }.should raise_error(ArgumentError)
      end
    end

    describe "for instance methods" do
      it "should complain when only one argument is passed" do
        lambda { @class.before(:hookable) }.should raise_error(ArgumentError)
        lambda { @class.after(:hookable) }.should raise_error(ArgumentError)
      end

      it "should complain when target_method is not a symbol" do
        lambda { @class.before("hookable", :ambiguous) }.should raise_error(ArgumentError)
        lambda { @class.after("hookable", :ambiguous) }.should raise_error(ArgumentError)
      end

      it "should complain when method_sym is not a symbol" do
        lambda { @class.before(:hookable, "ambiguous") }.should raise_error(ArgumentError)
        lambda { @class.after(:hookable, "ambiguous") }.should raise_error(ArgumentError)
      end

      it "should not allow methods ending in = to be hooks" do
        lambda { @class.before(:hookable, :annoying=) }.should raise_error(ArgumentError)
        lambda { @class.after(:hookable, :annoying=) }.should raise_error(ArgumentError)
      end
    end

  end

  #
  # Specs out how hook methods / blocks are invoked when there is no inheritance
  # involved
  #
  describe "hook invocation without inheritance" do

    describe "for class methods" do
      it 'should run an advice block' do
        @class.before_class_method(:clakable) { hi_mom! }
        @class.should_receive(:hi_mom!)
        @class.clakable
      end

      it 'should run an advice method' do
        @class.class_eval %{def self.before_method; hi_mom!; end;}
        @class.before_class_method(:clakable, :before_method)

        @class.should_receive(:hi_mom!)
        @class.clakable
      end

      it 'should pass the hookable method arguments to the hook method' do
        @class.class_eval %{def self.hook_this(word, lol); end;}
        @class.register_class_hooks(:hook_this)
        @class.before_class_method(:hook_this, :before_hook_this)

        @class.should_receive(:before_hook_this).with("omg", "hi2u")
        @class.hook_this("omg", "hi2u")
      end

      it 'should work with glob arguments (or whatever you call em)' do
        @class.class_eval %{def self.hook_this(*args); end;}
        @class.register_class_hooks(:hook_this)
        @class.before_class_method(:hook_this, :before_hook_this)

        @class.should_receive(:before_hook_this).with("omg", "hi2u", "lolercoaster")
        @class.hook_this("omg", "hi2u", "lolercoaster")
      end

      it 'should allow the use of before and after together' do
        @class.class_eval %{def self.before_hook; first!; end;}
        @class.before_class_method(:clakable, :before_hook)
        @class.after_class_method(:clakable) { last! }

        @class.should_receive(:first!).once.ordered
        @class.should_receive(:last!).once.ordered
        @class.clakable
      end
    end

    describe "for instance methods" do
      it 'should run an advice block' do
        @class.before(:hookable) { hi_mom! }

        inst = @class.new
        inst.should_receive(:hi_mom!)
        inst.hookable
      end

      it 'should run an advice method' do
        @class.send(:define_method, :before_method) { hi_mom! }
        @class.before(:hookable, :before_method)

        inst = @class.new
        inst.should_receive(:hi_mom!)
        inst.hookable
      end

      it 'should pass the hookable method arguments to the hook method' do
        @class.class_eval %{def hook_this(word, lol); end;}
        @class.register_instance_hooks(:hook_this)
        @class.before(:hook_this, :before_hook_this)

        inst = @class.new
        inst.should_receive(:before_hook_this).with("omg", "hi2u")
        inst.hook_this("omg", "hi2u")
      end

      it 'should work with glob arguments (or whatever you call em)' do
        @class.class_eval %{def hook_this(*args); end;}
        @class.register_instance_hooks(:hook_this)
        @class.before(:hook_this, :before_hook_this)

        inst = @class.new
        inst.should_receive(:before_hook_this).with("omg", "hi2u", "lolercoaster")
        inst.hook_this("omg", "hi2u", "lolercoaster")
      end

      it 'should allow the use of before and after together' do
        @class.class_eval %{def after_hook; last!; end;}
        @class.before(:hookable) { first! }
        @class.after(:hookable, :after_hook)

        inst = @class.new
        inst.should_receive(:first!).once.ordered
        inst.should_receive(:last!).once.ordered
        inst.hookable
      end

      it 'should be able to use private methods as hooks' do
        @class.class_eval %{private; def nike; doit!; end;}
        @class.before(:hookable, :nike)

        inst = @class.new
        inst.should_receive(:doit!)
        inst.hookable
      end
    end

  end

  describe "hook invocation with class inheritance" do

    describe "for class methods" do
      it 'should run an advice block when the class is inherited' do
        @class.before_class_method(:clakable) { hi_mom! }
        @child = Class.new(@class)
        @child.should_receive(:hi_mom!)
        @child.clakable
      end

      it 'should run an advice block on child class when hook is registered in parent after inheritance' do
        @child = Class.new(@class)
        @class.before_class_method(:clakable) { hi_mom! }
        @child.should_receive(:hi_mom!)
        @child.clakable
      end

      it 'should be able to declare advice methods in child classes' do
        @class.class_eval %{def self.before_method; hi_dad!; end;}
        @class.before_class_method(:clakable, :before_method)

        @child = Class.new(@class) do
          def self.child; hi_mom!; end;
          before_class_method(:clakable, :child)
        end

        @child.should_receive(:hi_dad!).once.ordered
        @child.should_receive(:hi_mom!).once.ordered
        @child.clakable
      end

      it "should not execute hooks added in the child classes when in the parent class" do
        @child = Class.new(@class) { def self.child; hi_mom!; end; }
        @child.before_class_method(:clakable, :child)
        @class.should_not_receive(:hi_mom!)
        @class.clakable
      end

      it 'should not call the hook stack if the hookable method is overwritten and does not call super' do
        @class.before_class_method(:clakable) { hi_mom! }
        @child = Class.new(@class) do
          def self.clakable; end;
        end

        @child.should_not_receive(:hi_mom!)
        @child.clakable
      end

      it 'should not call hooks defined in the child class for a hookable method in a parent if the child overwrites the hookable method without calling super' do
        @child = Class.new(@class) do
          before_class_method(:clakable) { hi_mom! }
          def self.clakable; end;
        end

        @child.should_not_receive(:hi_mom!)
        @child.clakable
      end

      it 'should not call hooks defined in child class even if hook method exists in parent' do
        @class.class_eval %{def self.hello_world; hello_world!; end;}
        @child = Class.new(@class) do
          before_class_method(:clakable, :hello_world)
        end

        @class.should_not_receive(:hello_world!)
        @class.clakable
      end
    end

    describe "for instance methods" do
      it 'should run an advice block when the class is inherited' do
        @inherited_class = Class.new(@class)
        @class.before(:hookable) { hi_dad! }

        inst = @inherited_class.new
        inst.should_receive(:hi_dad!)
        inst.hookable
      end

      it 'should run an advice block on child class when hook is registered in parent after inheritance' do
        @child = Class.new(@class)
        @class.before(:hookable) { hi_mom! }

        inst = @child.new
        inst.should_receive(:hi_mom!)
        inst.hookable
      end

      it 'should be able to declare advice methods in child classes' do
        @class.send(:define_method, :before_method) { hi_dad! }
        @class.before(:hookable, :before_method)

        @child = Class.new(@class) do
          def child; hi_mom!; end;
          before :hookable, :child
        end

        inst = @child.new
        inst.should_receive(:hi_dad!).once.ordered
        inst.should_receive(:hi_mom!).once.ordered
        inst.hookable
      end

      it "should not execute hooks added in the child classes when in parent class" do
        @child = Class.new(@class)
        @child.send(:define_method, :child) { hi_mom! }
        @child.before(:hookable, :child)

        inst = @class.new
        inst.should_not_receive(:hi_mom!)
        inst.hookable
      end



      it 'should not call the hook stack if the hookable method is overwritten and does not call super' do
        @class.before(:hookable) { hi_mom! }
        @child = Class.new(@class) do
          def hookable; end;
        end

        inst = @child.new
        inst.should_not_receive(:hi_mom!)
        inst.hookable
      end

      it 'should not call hooks defined in the child class for a hookable method in a parent if the child overwrites the hookable method without calling super' do
        @child = Class.new(@class) do
          before(:hookable) { hi_mom! }
          def hookable; end;
        end

        inst = @child.new
        inst.should_not_receive(:hi_mom!)
        inst.hookable
      end

      it 'should not call hooks defined in child class even if hook method exists in parent' do
        @class.send(:define_method, :hello_world) { hello_world! }
        @child = Class.new(@class) do
          before(:hookable, :hello_world)
        end

        inst = @class.new
        inst.should_not_receive(:hello_world!)
        inst.hookable
      end
    end

  end

  describe "hook invocation with module inclusions / extensions" do

    describe "for class methods" do
      it "should not overwrite methods included by extensions after the hook is declared" do
        @module.class_eval do
          @another_module = Module.new do
            def greet; greetings_from_another_module; super; end;
          end

          def self.extended(base)
            base.before_class_method(:clakable, :greet)
            base.extend(@another_module)
          end
        end

        @class.extend(@module)
        @class.should_receive(:greetings_from_another_module).once.ordered
        @class.should_receive(:greetings_from_module).once.ordered
        @class.clakable
      end
    end

    describe "for instance methods" do
      it 'should not overwrite methods included by modules after the hook is declared' do
        @module.class_eval do
          @another_module = Module.new do
            def greet; greetings_from_another_module; super; end;
          end

          def self.included(base)
            base.before(:hookable, :greet)
            base.send(:include, @another_module)
          end
        end

        @class.send(:include, @module)

        inst = @class.new
        inst.should_receive(:greetings_from_another_module).once.ordered
        inst.should_receive(:greetings_from_module).once.ordered
        inst.hookable
      end
    end

  end

  describe "hook invocation with unrelated classes" do

    describe "for class methods" do
      it "should not execute hooks registered in an unrelated class" do
        @class.before_class_method(:clakable) { hi_mom! }

        @other.should_not_receive(:hi_mom!)
        @other.clakable
      end
    end

    describe "for instance methods" do
      it "should not execute hooks registered in an unrelated class" do
        @class.before(:hookable) { hi_mom! }

        inst = @other.new
        inst.should_not_receive(:hi_mom!)
        inst.hookable
      end
    end

  end

  describe "using before hook" do

    describe "for class methods" do

      it 'should run the advice before the advised method' do
        @class.class_eval %{def self.hook_me; second!; end;}
        @class.register_class_hooks(:hook_me)
        @class.before_class_method(:hook_me, :first!)

        @class.should_receive(:first!).ordered
        @class.should_receive(:second!).ordered
        @class.hook_me
      end

      it 'should execute all advices once in order' do
        @class.before_class_method(:clakable, :hook_1)
        @class.before_class_method(:clakable, :hook_2)
        @class.before_class_method(:clakable, :hook_3)

        @class.should_receive(:hook_1).once.ordered
        @class.should_receive(:hook_2).once.ordered
        @class.should_receive(:hook_3).once.ordered
        @class.clakable
      end
    end

    describe "for instance methods" do

      it 'should run the advice before the advised method' do
        @class.class_eval %{
          def hook_me; second!; end;
        }
        @class.register_instance_hooks(:hook_me)
        @class.before(:hook_me, :first!)

        inst = @class.new
        inst.should_receive(:first!).ordered
        inst.should_receive(:second!).ordered
        inst.hook_me
      end

      it 'should execute all advices once in order' do
        @class.before(:hookable, :hook_1)
        @class.before(:hookable, :hook_2)
        @class.before(:hookable, :hook_3)

        inst = @class.new
        inst.should_receive(:hook_1).once.ordered
        inst.should_receive(:hook_2).once.ordered
        inst.should_receive(:hook_3).once.ordered
        inst.hookable
      end
    end

  end

  describe 'using after hook' do

    describe "for class methods" do

      it 'should run the advice after the advised method' do
        @class.class_eval %{def self.hook_me; first!; end;}
        @class.register_class_hooks(:hook_me)
        @class.after_class_method(:hook_me, :second!)

        @class.should_receive(:first!).ordered
        @class.should_receive(:second!).ordered
        @class.hook_me
      end

      it 'should execute all advices once in order' do
        @class.after_class_method(:clakable, :hook_1)
        @class.after_class_method(:clakable, :hook_2)
        @class.after_class_method(:clakable, :hook_3)

        @class.should_receive(:hook_1).once.ordered
        @class.should_receive(:hook_2).once.ordered
        @class.should_receive(:hook_3).once.ordered
        @class.clakable
      end

      it "the advised method should still return its normal value" do
        @class.class_eval %{def self.hello; "hello world"; end;}
        @class.register_class_hooks(:hello)
        @class.after_class_method(:hello) { "BAM" }

        @class.hello.should == "hello world"
      end

    end

    describe "for instance methods" do

      it 'should run the advice after the advised method' do
        @class.class_eval %{def hook_me; first!; end;}
        @class.register_instance_hooks(:hook_me)
        @class.after(:hook_me, :second!)

        inst = @class.new
        inst.should_receive(:first!).ordered
        inst.should_receive(:second!).ordered
        inst.hook_me
      end

      it 'should execute all advices once in order' do
        @class.after(:hookable, :hook_1)
        @class.after(:hookable, :hook_2)
        @class.after(:hookable, :hook_3)

        inst = @class.new
        inst.should_receive(:hook_1).once.ordered
        inst.should_receive(:hook_2).once.ordered
        inst.should_receive(:hook_3).once.ordered
        inst.hookable
      end

      it "the advised method should still return its normal value" do
        @class.class_eval %{def hello; "hello world"; end;}
        @class.register_instance_hooks(:hello)
        @class.after(:hello) { "BAM" }

        @class.new.hello.should == "hello world"
      end

    end

  end

  describe 'aborting' do

    describe "for class methods" do
      it "should catch :halt from a before hook and abort the advised method" do
        @class.class_eval %{def self.no_love; love_me!; end;}
        @class.register_class_hooks :no_love
        @class.before_class_method(:no_love) { maybe! }
        @class.before_class_method(:no_love) { throw :halt }
        @class.before_class_method(:no_love) { what_about_me? }

        @class.should_receive(:maybe!)
        @class.should_not_receive(:what_about_me?)
        @class.should_not_receive(:love_me!)
        lambda { @class.no_love }.should_not throw_symbol(:halt)
      end

      it "should not run after hooks if a before hook throws :halt" do
        @class.before_class_method(:clakable) { throw :halt }
        @class.after_class_method(:clakable) { bam! }

        @class.should_not_receive(:bam!)
        lambda { @class.clakable }.should_not throw_symbol(:halt)
      end

      it "should return nil from the hookable method if a before hook throws :halt" do
        @class.class_eval %{def self.with_value; "hello"; end;}
        @class.register_class_hooks(:with_value)
        @class.before_class_method(:with_value) { throw :halt }

        @class.with_value.should be_nil
      end

      it "should catch :halt from an after hook and cease the advice" do
        @class.after_class_method(:clakable) { throw :halt }
        @class.after_class_method(:clakable) { never_see_me! }

        @class.should_not_receive(:never_see_me!)
        lambda { @class.clakable }.should_not throw_symbol(:halt)
      end

      it "should still return the hookable methods return value if an after hook throws :halt" do
        @class.class_eval %{def self.with_value; "hello"; end;}
        @class.register_class_hooks(:with_value)
        @class.after_class_method(:with_value) { throw :halt }

        @class.with_value.should == "hello"
      end
    end

    describe "for instance methods" do
      it "should catch :halt from a before hook and abort the advised method" do
        @class.class_eval %{def no_love; love_me!; end;}
        @class.register_instance_hooks :no_love
        @class.before(:no_love) { maybe! }
        @class.before(:no_love) { throw :halt }
        @class.before(:no_love) { what_about_me? }

        inst = @class.new
        inst.should_receive(:maybe!)
        inst.should_not_receive(:what_about_me?)
        inst.should_not_receive(:love_me!)
        lambda { inst.no_love }.should_not throw_symbol(:halt)
      end

      it "should not run after hooks if a before hook throws :halt" do
        @class.before(:hookable) { throw :halt }
        @class.after(:hookable) { bam! }

        inst = @class.new
        inst.should_not_receive(:bam!)
        lambda { inst.hookable }.should_not throw_symbol(:halt)
      end

      it "should return nil from the hookable method if a before hook throws :halt" do
        @class.class_eval %{def with_value; "hello"; end;}
        @class.register_instance_hooks(:with_value)
        @class.before(:with_value) { throw :halt }

        @class.new.with_value.should be_nil
      end

      it "should catch :halt from an after hook and cease the advice" do
        @class.after(:hookable) { throw :halt }
        @class.after(:hookable) { never_see_me! }

        inst = @class.new
        inst.should_not_receive(:never_see_me!)
        lambda { inst.hookable }.should_not throw_symbol(:halt)
      end

      it "should still return the hookable methods return value if an after hook throws :halt" do
        @class.class_eval %{def with_value; "hello"; end;}
        @class.register_instance_hooks(:with_value)
        @class.after(:with_value) { throw :halt }

        @class.new.with_value.should == "hello"
      end
    end

  end

  describe "helper methods" do
    it 'should generate the correct argument signature' do
      @class.class_eval do
        def some_method(a, b, c)
          [a, b, c]
        end

        def yet_another(a, *heh)p
          [a, *heh]
        end
      end

      @class.args_for(@class.instance_method(:hookable)).should == ""
      @class.args_for(@class.instance_method(:some_method)).should == "_1, _2, _3"
      @class.args_for(@class.instance_method(:yet_another)).should == "_1, *args"
    end
  end

end
