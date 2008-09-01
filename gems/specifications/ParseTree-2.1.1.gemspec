Gem::Specification.new do |s|
  s.name = %q{ParseTree}
  s.version = "2.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ryan Davis"]
  s.date = %q{2007-12-22}
  s.description = %q{ParseTree is a C extension (using RubyInline) that extracts the parse tree for an entire class or a specific method and returns it as a s-expression (aka sexp) using ruby's arrays, strings, symbols, and integers.  As an example:  def conditional1(arg1) if arg1 == 0 then return 1 end return 0 end  becomes:  [:defn, :conditional1, [:scope, [:block, [:args, :arg1], [:if, [:call, [:lvar, :arg1], :==, [:array, [:lit, 0]]], [:return, [:lit, 1]], nil], [:return, [:lit, 0]]]]]  * Uses RubyInline, so it just drops in. * Includes SexpProcessor and CompositeSexpProcessor. * Allows you to write very clean filters. * Includes UnifiedRuby, allowing you to automatically rewrite ruby quirks. * ParseTree#parse_tree_for_string lets you parse arbitrary strings of ruby. * Includes parse_tree_show, which lets you quickly snoop code. * echo "1+1" | parse_tree_show -f for quick snippet output. * Includes parse_tree_abc, which lets you get abc metrics on code. * abc metrics = numbers of assignments, branches, and calls. * whitespace independent metric for method complexity. * Includes parse_tree_deps, which shows you basic class level dependencies. * Does not work on the core classes, as they are not ruby (yet).}
  s.email = %q{ryand-ruby@zenspider.com}
  s.executables = ["parse_tree_abc", "parse_tree_audit", "parse_tree_deps", "parse_tree_show"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "bin/parse_tree_abc", "bin/parse_tree_audit", "bin/parse_tree_deps", "bin/parse_tree_show", "demo/printer.rb", "lib/composite_sexp_processor.rb", "lib/parse_tree.rb", "lib/sexp.rb", "lib/sexp_processor.rb", "lib/unified_ruby.rb", "lib/unique.rb", "test/pt_testcase.rb", "test/something.rb", "test/test_all.rb", "test/test_composite_sexp_processor.rb", "test/test_parse_tree.rb", "test/test_sexp.rb", "test/test_sexp_processor.rb", "test/test_unified_ruby.rb", "validate.sh"]
  s.has_rdoc = true
  s.homepage = %q{http://www.zenspider.com/ZSS/Products/ParseTree/}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib", "test"]
  s.rubyforge_project = %q{parsetree}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{ParseTree is a C extension (using RubyInline) that extracts the parse tree for an entire class or a specific method and returns it as a s-expression (aka sexp) using ruby's arrays, strings, symbols, and integers.}
  s.test_files = ["test/test_all.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<RubyInline>, [">= 3.6.0"])
      s.add_runtime_dependency(%q<hoe>, [">= 1.4.0"])
    else
      s.add_dependency(%q<RubyInline>, [">= 3.6.0"])
      s.add_dependency(%q<hoe>, [">= 1.4.0"])
    end
  else
    s.add_dependency(%q<RubyInline>, [">= 3.6.0"])
    s.add_dependency(%q<hoe>, [">= 1.4.0"])
  end
end
