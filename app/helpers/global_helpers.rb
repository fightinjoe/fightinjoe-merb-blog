module Merb
  module GlobalHelpers
    def input_tag( object, name, type )
      '<input type="%s" name="%s" value="%s" />' % [ type, name, object.send(name) ]
    end
  end
end    