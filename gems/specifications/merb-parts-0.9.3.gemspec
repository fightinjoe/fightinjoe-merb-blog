Gem::Specification.new do |s|
  s.name = %q{merb-parts}
  s.version = "0.9.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Hassox"]
  s.autorequire = %q{merb-parts}
  s.date = %q{2008-05-04}
  s.description = %q{Merb More: Merb plugin that provides Part Controllers.}
  s.email = %q{}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "lib/merb-parts", "lib/merb-parts/merbtasks.rb", "lib/merb-parts/mixins", "lib/merb-parts/mixins/web_controller.rb", "lib/merb-parts/part_controller.rb", "lib/merb-parts.rb", "spec/fixtures", "spec/fixtures/controllers", "spec/fixtures/controllers/main.rb", "spec/fixtures/parts", "spec/fixtures/parts/todo_part.rb", "spec/fixtures/parts/views", "spec/fixtures/parts/views/layout", "spec/fixtures/parts/views/layout/todo_part.html.erb", "spec/fixtures/parts/views/layout/todo_part.xml.erb", "spec/fixtures/parts/views/todo_part", "spec/fixtures/parts/views/todo_part/formatted_output.html.erb", "spec/fixtures/parts/views/todo_part/formatted_output.js.erb", "spec/fixtures/parts/views/todo_part/formatted_output.xml.erb", "spec/fixtures/parts/views/todo_part/list.html.erb", "spec/fixtures/parts/views/todo_part/part_with_params.html.erb", "spec/fixtures/views", "spec/fixtures/views/main", "spec/fixtures/views/main/part_within_view.html.erb", "spec/merb-parts_spec.rb", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://merb-plugins.rubyforge.org/merb-parts/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Merb More: Merb plugin that provides Part Controllers.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<merb-core>, [">= 0.9.3"])
    else
      s.add_dependency(%q<merb-core>, [">= 0.9.3"])
    end
  else
    s.add_dependency(%q<merb-core>, [">= 0.9.3"])
  end
end
