module Merb
  module Helpers
    module Tag

      # Generates a HTML link element
      #
      # ==== Example
      #     <%= link( 'Click Here', 'http://www.google.com', :title => 'A link to Google' ) %>
      #
      #     => <a href="http://www.google.com" title="A link to Google">Click Here</a>
      def link( content, url, attrs = {} )
        attrs[:href] = url
        tag( 'a', content, attrs )
      end

    end

    module Form
      # Used within a +form_for+ resource block, this will generate a label pointing to the
      # form element for +attribute+.  By default, if no +content+ for the label is passed,
      # the label's text will read the capitalized +attribute+
      #
      # ==== Example
      #     <%= label_for(:title, 'Enter the title') %>
      #
      #     => <label for="blog_title">Enter the title</label>
      def label_for( attribute, content = nil, attrs = {} )
        content ||= attribute.to_s.capitalize
        attrs[:id] = control_id( attribute )
        label( content, '', attrs )
      end
    end
  end
end