module ProductsHelper

  def nested_product_category_rows2(category, current_category = nil, link_to_current = true, relative_depth = 0)
    if category.present? && category.children.count > 0
      ''.tap do |s|
        # s << "<!-- #{category.name} CatDepth: #{category.depth} -->"
        category.children.ordered.each do |child|
          # s << "<!-- #{child.name} ChilDepth: #{child.depth} -->"
          unless child.depth == 2
            anchor = true
            s << "<a id='#{child.permalink}' href='##{child.id}-cat' class='list-group-item' data-toggle='collapse' data-parent='##{child.id}-cat' onclick='getProducts(this)'>"
            s << "#{child.name} #{add_arrow(child)}"
            s << "</a>"
            s << "<li class='collapse list-group-submenu' id='#{child.id}-cat'>"
          end

          if anchor == true
          else
            s << "#{link_to("#{child.name} #{add_arrow(child)}".html_safe, products_path(category_permalink: child.permalink), {:class=>'list-group-item', :'data-toggle'=>'collapse', :'data-parent'=>'#SubMenu1', :remote => true}).html_safe}"
          end

          s << nested_product_category_rows2(child, current_category, link_to_current, relative_depth)
          if child.depth < 2
            s << "</li>"
          end
        end
      end.html_safe
    else
      ''
    end
  end

  def add_arrow(category)
    if category.children.count > 0
      return "<i class='fa fa-caret-down'></i>".html_safe
    else
      ""
    end
  end

  def get_category_sequence(product)
    category = product.get_categories.try(:last)
    if category
    return category.hierarchy_array.collect(&:name).join(" / ")
    end
    return ""
  end

  def product_for_rating(product)
    return product.parent if product.variant?
    return product
  end

  def product_image(product)
    product = product.parent if product.default # get default variant here
    return product.default_image.file.try(:standard) if product.try(:default_image)
    return '/assets/placeholder.jpg'
  end

end
