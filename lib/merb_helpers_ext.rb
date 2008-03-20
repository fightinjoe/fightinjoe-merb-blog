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

      def remote_link( content, js, attrs = {} )
        attrs[:href]    = '#'
        attrs[:onclick] = 'javascript:%s;return false;' % js
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

      def options_for_selectt(collection, attrs = {})
        prompt     = attrs.delete(:prompt)
        blank      = attrs.delete(:include_blank)
        selected   = attrs.delete(:selected)
        ret = String.new
        ret << tag('option', prompt, :value => '') if prompt
        ret << tag("option", '', :value => '') if blank
        unless collection.blank?
          if collection.is_a?(Hash)
            collection.each do |label,group|
              ret << open_tag("optgroup", :label => label.to_s.gsub(/\b[a-z]/) {|x| x.upcase}) + 
                options_for_select(group, :selected => selected) + "</optgroup>"
            end
          else
            collection.each do |value,text|
              text ||= value
              options = selected.to_a.include?(value) ? {:selected => 'selected'} : {}
              ret << tag( 'option', text, {:value => value}.merge(options) )
            end
          end
        end

        return ret
      end

    end
  end
end