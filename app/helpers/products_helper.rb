module ProductsHelper
  def nested_product_category_spacing_adjusted_for_depth2(category, relative_depth)
    depth = category.depth - relative_depth
    spacing = depth < 2 ? 0.8 : 1.5
    ("<span style='display:inline-block;width:#{spacing}em;'></span>" * category.depth).html_safe
  end

  def nested_product_category_rows2(category, current_category = nil, link_to_current = true, relative_depth = 0)
    if category.present? && category.children.count > 0
      ''.tap do |s|
        category.children.ordered.each do |child|
          # s << "<a href='#women-Casual' class='list-group-item' data-toggle='collapse' data-parent='#women-Casual'>"
          # s << '<td>'
          if child == current_category
            # byebug
            # if link_to_current == false
            #   byebug # if
            #   s << "#{child.name} (#{t('shoppe.product_category.nesting.current_category')})"
            # else
            #   byebug # else
            #   s << "#{link_to(child.name, "#").html_safe} (#{t('shoppe.product_category.nesting.current_category')})"
            # end
          else
            # s << "<div class='collapse' id='#{category.name}'>"
            # byebug
             s << "<!-- #{category.name}AA -->"
             s << "<a href='##{category.name}' class='list-group-item' data-toggle='collapse' data-parent='##{category.name}'>"
             s << "<li class='collapse list-group-submenu' id='#{category.name}'>"
            s << "<!-- inner -->"
            s << "#{link_to("#{child.name} <i class='fa fa-caret-down'></i>".html_safe, products_path(category_id: child.id), {:class=>'list-group-item', :'data-toggle'=>'collapse', :'data-parent'=>'#SubMenu1', :remote => true}).html_safe}"
            
          end
          # s << (link_to I18n.t('shoppe.products.products'), products_path(category_id: child.id), style: 'float: right')
          # s << '</td>'
          s << nested_product_category_rows2(child, current_category, link_to_current, relative_depth)
          # s << '</div>'
          s << "</li>"
          s << "</a>"
        end
      end.html_safe
    else
      ''
    end
  end
end
