module LayoutHelper

  def title(page_title, show_topbar = true, show_sidebar = true)
    content_for(:title) { page_title.to_s }
    @show_topbar = show_topbar
    @show_sidebar = show_sidebar
  end

  def show_sidebar?
    @show_sidebar
  end

  def show_topbar?
    @show_topbar
  end

end
