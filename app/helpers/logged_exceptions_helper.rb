module Merb
  module LoggedExceptionsHelper
    def filtered?
      [:query, :date_ranges_filter, :exception_names_filter, :controller_actions_filter].any? { |p| params[p] }
    end

    def pagination_remote_links(paginator, options={}, html_options={})
       name   = options[:name]    || ActionController::Pagination::DEFAULT_OPTIONS[:name]
       params = (options[:params] || ActionController::Pagination::DEFAULT_OPTIONS[:params]).clone

       'links go here'
       #pagination_links_each(paginator, options) do |n|
       #  params[name] = n
       #  link_to_function n.to_s, "ExceptionLogger.setPage(#{n})"
       #end
    end

    def cycle( *opts )
      @cycle = @cycle ? @cycle+1 : 0
      opts[ @cycle % opts.size ]
    end

    def print_hash( hash )
      return hash unless hash.is_a?( Hash )
      max = hash.keys.max { |a,b| a.to_s.length <=> b.to_s.length }
      out = hash.keys.collect(&:to_s).sort.inject [] do |out, key|
        out << '* ' + ("%*s: %s" % [max.to_s.length, key, hash[key].to_s.strip])
      end

      "<pre>\n#{ out * "\n" }</pre>"
    end

    def print_page_links( paginated_object )
      links = []
      paginated_object.number_of_pages.times do |i|
        links << link( i+1, url(:action => 'index', :page => i+1) )
      end
      links * ' '
    end
  end
end