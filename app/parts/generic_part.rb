class GenericPart < Merb::PartController

  def sidebar
    @about      = Category.first(:title => 'About')
    @categories = Category.all - [@about]
    render
  end

end
