Gem::Specification.new do |s|
  s.name = %q{paginator}
  s.version = "1.1.0"
  s.date = %q{2007-08-12}
  s.summary = %q{A generic paginator object for use in any Ruby program}
  s.email = %q{bruce@codefluency.com}
  s.homepage = %q{http://paginator.rubyforge.org}
  s.rubyforge_project = %q{paginator}
  s.description = %q{Paginator doesn't make any assumptions as to how data is retrieved; you just have to provide it with the total number of objects and a way to pull a specific set of objects based on the offset and number of objects per page.}
  s.default_executable = %q{paginator}
  s.has_rdoc = true
  s.authors = ["Bruce Williams"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "bin/paginator", "lib/paginator.rb", "test/test_paginator.rb"]
  s.test_files = ["test/test_paginator.rb"]
  s.rdoc_options = ["--main", "README.txt"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.executables = ["paginator"]
  s.add_dependency(%q<hoe>, [">= 1.2.1"])
end
