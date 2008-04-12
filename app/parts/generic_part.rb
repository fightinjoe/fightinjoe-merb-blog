class GenericPart < Merb::PartController

  def sidebar
    @about      = Category.first(:title => 'About')
    @categories = Category.all - [@about]
    @sel_category = @categories.index( params[:category] )

    render
  end

end
