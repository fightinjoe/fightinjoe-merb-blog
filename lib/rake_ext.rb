# From http://blog.jayfields.com/2008/02/rake-task-overwriting.html
# ==== Example
#  Rake::Task[:the_task].abandon
#   
#  Rake::Task[:the_task].overwrite do
#    p "two"
#  end
#
#  Rake::TestTask.new(:the_task) do |t|
#    t.libs << "test"
#    t.pattern = 'test/**/*_test.rb'
#    t.verbose = true
#  end
class Rake::Task
  def overwrite(&block)
    @actions.clear
    prerequisites.clear
    enhance(&block)
  end
  def abandon
    prerequisites.clear
    @actions.clear
  end
end