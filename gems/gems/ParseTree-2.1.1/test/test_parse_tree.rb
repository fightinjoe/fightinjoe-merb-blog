#!/usr/local/bin/ruby -w

dir = File.expand_path "~/.ruby_inline"
if test ?d, dir then
  require 'fileutils'
  puts "nuking #{dir}"
  FileUtils.rm_r dir
end

require 'test/unit'
require 'parse_tree'
require 'pt_testcase'
require 'test/something'

class SomethingWithInitialize
  def initialize; end # this method is private
  protected
  def protected_meth; end
end

class ParseTree
  def process(input) # makes it play with with ParseTreeTestCase (FIX?)
    # um. kinda stupid, but cleaner
    case input
    when Array then
      ParseTree.translate(*input)
    else
      ParseTree.translate(input)
    end
  end
end

class TestParseTree < ParseTreeTestCase
  def setup
    super
    @processor = ParseTree.new(false)
  end

  def test_class_initialize
    expected = [[:class, :SomethingWithInitialize, [:const, :Object],
      [:defn, :initialize, [:scope, [:block, [:args], [:nil]]]],
      [:defn, :protected_meth, [:scope, [:block, [:args], [:nil]]]],
    ]]
    tree = @processor.parse_tree SomethingWithInitialize
    assert_equal expected, tree
  end

  def test_class_translate_string
    str = "class A; def a; end; end"

    sexp = ParseTree.translate str

    expected = [:class, :A, nil,
                 [:scope,
                   [:defn, :a, [:scope, [:block, [:args], [:nil]]]]]]

    assert_equal expected, sexp
  end

  def test_class_translate_string_method
    str = "class A; def a; end; def b; end; end"

    sexp = ParseTree.translate str, :a

    expected = [:defn, :a, [:scope, [:block, [:args], [:nil]]]]

    assert_equal expected, sexp
  end

  def test_parse_tree_for_string
    actual   = @processor.parse_tree_for_string '1 + nil', '(string)', 1
    expected = [[:call, [:lit, 1], :+, [:array, [:nil]]]]

    assert_equal expected, actual
  end

  def test_parse_tree_for_string_with_newlines
    @processor = ParseTree.new(true)
    actual   = @processor.parse_tree_for_string "1 +\n nil", 'test.rb', 5
    expected = [[:newline, 6, "test.rb", 
                 [:call, [:lit, 1], :+, [:array, [:nil]]]]]

    assert_equal expected, actual
  end

  def test_parse_tree_for_str
    actual   = @processor.parse_tree_for_str '1 + nil', '(string)', 1
    expected = [[:call, [:lit, 1], :+, [:array, [:nil]]]]

    assert_equal expected, actual
  end

  @@self_classmethod = [:defs,
                        [:self], :classmethod,
                        [:scope,
                         [:block,
                          [:args],
                          [:call, [:lit, 1], :+, [:array, [:lit, 1]]]]]]

  @@missing = [nil]

  @@opt_args = [:defn, :opt_args,
    [:scope,
      [:block,
        [:args, :arg1, :arg2, :"*args", [:block, [:lasgn, :arg2, [:lit, 42]]]],
        [:lasgn, :arg3,
          [:call,
            [:call,
              [:lvar, :arg1],
              :*,
              [:array, [:lvar, :arg2]]],
            :*,
            [:array, [:lit, 7]]]],
        [:fcall, :puts, [:array, [:call, [:lvar, :arg3], :to_s]]],
        [:return,
          [:str, "foo"]]]]]
  @@multi_args = [:defn, :multi_args,
    [:scope,
      [:block,
        [:args, :arg1, :arg2],
        [:lasgn, :arg3,
          [:call,
            [:call,
              [:lvar, :arg1],
              :*,
              [:array, [:lvar, :arg2]]],
            :*,
            [:array, [:lit, 7]]]],
        [:fcall, :puts, [:array, [:call, [:lvar, :arg3], :to_s]]],
        [:return,
          [:str, "foo"]]]]]
  @@unknown_args = [:defn, :unknown_args,
    [:scope,
      [:block,
        [:args, :arg1, :arg2],
        [:return, [:lvar, :arg1]]]]]
  @@bbegin = [:defn, :bbegin,
    [:scope,
      [:block,
        [:args],
        [:begin,
          [:ensure,
            [:rescue,
              [:lit, 1],
              [:resbody,
                [:array, [:const, :SyntaxError]],
                [:block, [:lasgn, :e1, [:gvar, :$!]], [:lit, 2]],
                [:resbody,
                  [:array, [:const, :Exception]],
                  [:block, [:lasgn, :e2, [:gvar, :$!]], [:lit, 3]]]],
              [:lit, 4]],
            [:lit, 5]]]]]]
  @@bbegin_no_exception = [:defn, :bbegin_no_exception,
    [:scope,
      [:block,
        [:args],
        [:begin,
          [:rescue,
            [:lit, 5],
            [:resbody, nil, [:lit, 6]]]]]]]

  @@determine_args = [:defn, :determine_args,
    [:scope,
      [:block,
        [:args],
          [:call,
            [:lit, 5],
            :==,
            [:array,
              [:fcall,
                :unknown_args,
                [:array, [:lit, 4], [:str, "known"]]]]]]]]


  @@attrasgn = [:defn,
    :attrasgn,
    [:scope,
      [:block,
        [:args],
        [:attrasgn, [:lit, 42], :method=, [:array, [:vcall, :y]]],
        [:attrasgn,
          [:self],
          :type=,
          [:array, [:call, [:vcall, :other], :type]]]]]]

  @@__all = [:class, :Something, [:const, :Object]]

  Something.instance_methods(false).sort.each do |meth|
    if class_variables.include?("@@#{meth}") then
      @@__all << eval("@@#{meth}")
      eval "def test_#{meth}; assert_equal @@#{meth}, @processor.parse_tree_for_method(Something, :#{meth}); end"
    else
      eval "def test_#{meth}; flunk \"You haven't added @@#{meth} yet\"; end"
    end
  end

  Something.singleton_methods.sort.each do |meth|
    next if meth =~ /yaml/ # rubygems introduced a bug
    if class_variables.include?("@@self_#{meth}") then
      @@__all << eval("@@self_#{meth}")
      eval "def test_self_#{meth}; assert_equal @@self_#{meth}, @processor.parse_tree_for_method(Something, :#{meth}, true); end"
    else
      eval "def test_self_#{meth}; flunk \"You haven't added @@self_#{meth} yet\"; end"
    end
  end

  def test_missing
    assert_equal(@@missing,
                 @processor.parse_tree_for_method(Something, :missing),
                 "Must return -3 for missing methods")
  end

  def test_whole_class
    assert_equal([@@__all],
                 @processor.parse_tree(Something),
                 "Must return a lot of shit")
  end
end
