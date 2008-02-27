module Merb
    module BlogsHelper
      def blog_path( blog )
        id = blog.is_a?( Blog ) ? blog.id : blog
        '%4d/%02d/%s' % [ blog.created_at.year, blog.created_at.month, blog.path_title ]
      end

      def blogs_path
        '/blogs/'
      end
    end
end