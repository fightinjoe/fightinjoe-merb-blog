###
### $Rev: 77 $
### $Release: 2.5.0 $
### copyright(c) 2006-2008 kuwata-lab.com all rights reserved.
###

require 'yaml'

require 'test/unit/testcase'


class Test::Unit::TestCase


  def self.load_yaml_datafile(filename, options={}, &block)  # :nodoc:
    # read datafile
    s = File.read(filename)
    if filename =~ /\.rb$/
      s =~ /^__END__$/   or raise "*** error: __END__ is not found in '#{filename}'."
      s = $'
    end
    # untabify
    unless options[:tabify] == false
      s = s.inject('') do |sb, line|
        sb << line.gsub(/([^\t]{8})|([^\t]*)\t/n) { [$+].pack("A8") }
      end
    end
    # load yaml document
    testdata_list = []
    YAML.load_documents(s) do |ydoc|
      if ydoc.is_a?(Hash)
        testdata_list << ydoc
      elsif ydoc.is_a?(Array)
        ydoc.each do |hash|
          raise "testdata should be a mapping." unless hash.is_a?(Hash)
          testdata_list << hash
        end
      else
        raise "testdata should be a mapping."
      end
    end
    # data check
    identkey = options[:identkey] || 'name'
    table = {}
    testdata_list.each do |hash|
      ident = hash[identkey]
      ident          or  raise "*** key '#{identkey}' is required but not found."
      table[ident]   and raise "*** #{identkey} '#{ident}' is duplicated."
      table[ident] = hash
      yield(hash) if block
    end
    #
    return testdata_list
  end


  def self.define_testmethods(testdata_list, options={}, &block)
    identkey   = options[:identkey]   || 'name'
    testmethod = options[:testmethod] || '_test'
    testdata_list.each do |hash|
      yield(hash) if block
      ident = hash[identkey]
      s  =   "def test_#{ident}\n"
      hash.each do |key, val|
        s << "  @#{key} = #{val.inspect}\n"
      end
      s  <<  "  #{testmethod}\n"
      s  <<  "end\n"
      $stderr.puts "*** load_yaml_testdata(): eval_str=<<'END'\n#{s}END" if $DEBUG
      self.module_eval s
    end
  end


end
