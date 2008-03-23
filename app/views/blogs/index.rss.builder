xml.rss(:version => '2.0', :'xmlns:opensearch' => "http://a9.com/-/spec/opensearch/1.1/", :'xmlns:atom' => "http://www.w3.org/2005/Atom") do
  xml.channel do
    xml.title       'Fightinjoe: Blogs'
    xml.link        'http://www.fightinjoe.com/blogs.rss'
    xml.description 'Fightinjoe.com: Blogs'
    for blog in @blogs
      xml.item do
        xml.title blog.title
        xml.link( request.protocol + request.host + url(:blog_by_date, blog) )
        xml.guid( request.protocol + request.host + url(:blog_by_date, blog) )
        xml.description blog.body_html
        xml.pubDate blog.published_at
      end
    end
  end
end