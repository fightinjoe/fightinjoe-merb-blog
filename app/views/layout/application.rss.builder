xml.rss(:version => '2.0', :'xmlns:opensearch' => "http://a9.com/-/spec/opensearch/1.1/", :'xmlns:atom' => "http://www.w3.org/2005/Atom") do
  xml.channel do
    xml.title       @title
    xml.link        @link
    xml.description @description
    xml << catch_content( :for_layout )
  end
end