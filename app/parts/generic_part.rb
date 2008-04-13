class GenericPart < Merb::PartController

  def sidebar
    @about        = Category.first(:title => 'About')
    @categories   = Category.all - [@about]
    @sel_category = ([@about] + @categories).index( params[:category] ) || -1

    render
  end

end
