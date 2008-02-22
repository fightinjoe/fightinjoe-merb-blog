module Merb
  module GlobalHelper
    
    def blog_path( blog )
      id = blog.is_a?( Blog ) ? blog.id : blog
      blogs_path / id
    end

    def blogs_path
      '/blogs/'
    end

    def input_tag( object, name, type )
      '<input type="%s" name="%s" value="%s" />' % [ type, name, object.send(name) ]
    end
  end
end    