@title       = 'Fightinjoe: Comments'
@link        = 'http://www.fightinjoe.com/comments.rss'
@description = 'Most recent comments for blogs at Fightinjoe.com'

for comment in @comments
  xml.item do
    xml.title 'Comment by %s' % comment.author_name
    sig = '<hr/>' + [comment.author_name_and_email, comment.author_website].join(', ')
    xml.description comment.body.to_s + sig

    if comment.blog
      url = absolute_url(:blog_by_date, comment.blog)
      xml.link( url )
      xml.guid( '%s#comment_%d' % [ url, comment.id ] )
    else
      xml.guid( "#comment_%d" % comment.id )
    end

    xml.pubDate to_rfc822( comment.created_at )
  end
end