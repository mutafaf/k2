module ProductsHelper
  # def nested_product_category_spacing_adjusted_for_depth2(category, relative_depth)
  #   depth = category.depth - relative_depth
  #   # byebug
  #   spacing = depth < 2 ? 0.8 : 1.5
  #   ("<span style='display:inline-block;width:#{spacing}em;'></span>" * category.depth).html_safe
  # end

  def nested_product_category_rows2(category, current_category = nil, link_to_current = true, relative_depth = 0)
    if category.present? && category.children.count > 0
      ''.tap do |s|
        s << "<!-- #{category.name} CatDepth: #{category.depth} -->"
        category.children.ordered.each do |child|
          s << "<!-- #{child.name} ChilDepth: #{child.depth} -->"
          unless child.depth == 2
            anchor = true
            s << "<a href='##{child.name}' class='list-group-item' data-toggle='collapse' data-parent='##{child.name}'>"
            s << "#{child.name} #{add_arrow(child)}"
            s << "</a>"
            s << "<li class='collapse list-group-submenu' id='#{child.name}'>"
          end

          if child == current_category
            # if link_to_current == false
            #   s << "#{nested_product_category_spacing_adjusted_for_depth child, relative_depth} &#8627; #{child.name} (#{t('shoppe.product_category.nesting.current_category')})"
            # else
            #   s << "#{nested_product_category_spacing_adjusted_for_depth child, relative_depth} &#8627; #{link_to(child.name, [:edit, child]).html_safe} (#{t('shoppe.product_category.nesting.current_category')})"
            # end
          else
          end

          if anchor == true
          else
            s << "#{link_to("#{child.name} #{add_arrow(child)}".html_safe, products_path(category_id: child.id), {:class=>'list-group-item', :'data-toggle'=>'collapse', :'data-parent'=>'#SubMenu1'}).html_safe}"
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
end
