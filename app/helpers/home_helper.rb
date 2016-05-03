module HomeHelper

  def get_featured_category_class(index)
    if index > 1
      return "col-md-4 col-sm-4 col-xs-4"
    end
    return "col-md-6 col-sm-6 col-xs-6"
  end

  def get_homepage_title(title)
    s = ""
    title = title.split(" ")
    if title.size >= 2
      s << title.first
      s << "<span> #{title.last} </span>"
    else
      s << title.first
    end
    return s.html_safe
  end

end
