unless Object.instance_methods.include?('try')
  class Object
    def try( method )
      self.send( method ) if self.respond_to?( method )
    end
  end
end
