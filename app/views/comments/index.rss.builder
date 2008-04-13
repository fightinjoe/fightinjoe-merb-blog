xml.rss(:version => '2.0', :'xmlns:opensearch' => "http://a9.com/-/spec/opensearch/1.1/", :'xmlns:atom' => "http://www.w3.org/2005/Atom") do
  xml.channel do
    xml.title       'Fightinjoe: Comments'
    xml.link        'http://www.fightinjoe.com/comments.rss'
    xml.description 'Most recent comments for blogs at Fightinjoe.com'
    for comment in @comments
      xml.item do
        xml.title 'Title'
        xml.link 'http://www.google.com'
        xml.description 'Description'
        xml.title 'Comment by %s' % comment.author_name
        if comment.blog
          xml.link( request.protocol + request.host + url(:blog_by_date, comment.blog) )
          id = comment.id
          xml.guid( request.protocol + request.host + url(:blog_by_date, comment.blog) + "#comment_#{ id }" )
        end

        sig = '<hr/>' + [comment.author_name_and_email, comment.author_website].join(', ')
        xml.description comment.body.to_s + sig
        xml.pubDate comment.created_at
      end
    end
  end
end