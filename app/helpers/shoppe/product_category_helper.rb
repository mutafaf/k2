module Shoppe
  module ProductCategoryHelper
    def nested_product_category_spacing_adjusted_for_depth(category, relative_depth)
      depth = category.depth - relative_depth
      spacing = depth < 2 ? 0.8 : 1.5
      ("<span style='display:inline-block;width:#{spacing}em;'></span>" * category.depth).html_safe
    end

    def nested_product_category_rows(category, current_category = nil, link_to_current = true, relative_depth = 0)
      if category.present? && category.children.count > 0
        ''.tap do |s|
          
          # @s=category.children.order(:position)
          category.children.custom_ordered.each do |child|
            s << '<tr>'
            s << '<td>' 
            if child == current_category

              if link_to_current == false
                s << "#{nested_product_category_spacing_adjusted_for_depth child, relative_depth} &#8627; #{check_brackets(child.position)}  #{child.name} (#{t('shoppe.product_category.nesting.current_category')})"
              else
                s << "#{nested_product_category_spacing_adjusted_for_depth child, relative_depth} &#8627;  #{check_brackets(child.position)}   #{link_to(child.name, [:edit, child]).html_safe} (#{t('shoppe.product_category.nesting.current_category')})"
              end
            else
              s << "#{nested_product_category_spacing_adjusted_for_depth child, relative_depth} &#8627;  #{check_brackets(child.position)}   #{link_to(child.name, [:edit, child]).html_safe}"
            end
            s << (link_to I18n.t('shoppe.products.products'), products_path(category_id: child.id), style: 'float: right')
            s << '</td>'
            s << '</tr>'
            s << nested_product_category_rows(child, current_category, link_to_current, relative_depth)
          end
        end.html_safe
      else
        ''
      end
    end

    def check_brackets(number)
      if number.present?
        return "(#{number})"
      end
    end 

  end
end
