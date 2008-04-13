@title       = 'Fightinjoe: Blogs'
@link        = 'http://www.fightinjoe.com/blogs.rss'
@description = 'Fightinjoe.com: Blogs'

for blog in @blogs
  xml.item do
    xml.title blog.title
    xml.link( request.protocol + request.host + url(:blog_by_date, blog) )
    xml.guid( request.protocol + request.host + url(:blog_by_date, blog) )
    xml.description blog.body_html
    xml.pubDate blog.published_at
  end
end