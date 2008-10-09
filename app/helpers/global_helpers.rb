module Merb
  module GlobalHelpers
    # helpers defined here available to all views.  
    def print_date( date )
      months = %w(x Jan Feb Mar Apr May Jun Jul Aug Sept Oct Nov Dec)
      '<div class="date"><span class="month">%s</span><span class="day">%.2d</span></div>' %
        [ months[date.month], date.day ]
    end
  end
end
