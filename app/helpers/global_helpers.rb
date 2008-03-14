module Merb
  module GlobalHelpers

    def print_flash
      return unless flash[:error] || flash[:notice]
      klass = flash[:error] ? 'errors' : 'notice'
      out = <<-EOS
      <div class="#{ klass }" id="flash">
        #{ flash[:error] || flash[:notice] }
      </div>
      EOS
      out << "<script type='text/javascript'>setTimeout( function(){ $('#flash').fadeOut(2*1000) }, 5*1000 );</script>" if flash[:notice]
      out
    end

  end
end    