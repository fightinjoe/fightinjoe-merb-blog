module Merb
  module BlogsHelper
    def blog_actions( blog )
      <<-EOS
      <ul class="unlist horizontal right">
        <li>#{link( 'New',  url(:new_blog) ) }</li>
        <li>#{link( 'Edit', url(:edit_blog, @blog) ) }</li>
        <li>#{link( 'Logout', url(:logout) ) }</li>
      </ul>
      EOS
    end
  end
end