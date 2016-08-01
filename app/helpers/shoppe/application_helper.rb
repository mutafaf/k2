module Shoppe
  module ApplicationHelper
    def navigation_manager_link(item)
      link_to item.description, item.url(self), item.link_options.merge(class: item.active?(self) ? 'active' : 'inactive')
    end

    def status_tag(status)
      if status == "canceled" || status == "returned"
        content_tag :span, t("shoppe.orders.statuses.#{status}"), class: "status-tag rejected"
      else
        content_tag :span, t("shoppe.orders.statuses.#{status}"), class: "status-tag #{status}"
      end
    end

    def attachment_preview(attachment, options = {})
      if attachment.present? && attachment.token.present?
        ''.tap do |s|
          style = if attachment.image?
                    "style='background-image:url(#{attachment.file.thumb.url})'"
                  else
                    ''
          end
          s << "<div class='attachmentPreview #{attachment.image? ? 'image' : 'doc'}'>"
          s << "<div class='imgContainer'><div class='img' #{style}></div></div>"
          s << "<div class='desc'>"
          s << "<span class='filename'><a href='#{attachment.file.url}'>#{attachment.file_name}</a></span>"
          s << "<span class='delete'>"
          s << link_to(t('helpers.attachment_preview.delete', default: 'Delete this file?'), attachment_path(attachment.token), method: :delete, data: { confirm: t('helpers.attachment_preview.delete_confirm', default: 'Are you sure you wish to remove this attachment?') })
          s << '</span>'
          s << '</div>'
          s << '</div>'
        end.html_safe
      elsif !options[:hide_if_blank]
        "<div class='attachmentPreview'><div class='imgContainer'><div class='img none'></div></div><div class='desc none'>#{t('helpers.attachment_preview.no_attachment')},</div></div>".html_safe
      end
    end

    def settings_label(field)
      "<label for='settings_#{field}'>#{t("shoppe.settings.labels.#{field}")}</label>".html_safe
    end

    def settings_field(field, options = {})
      default = I18n.t('shoppe.settings.defaults')[field.to_sym]
      value = (params[:settings] && params[:settings][field]) || Shoppe.settings[field.to_s]
      type = I18n.t('shoppe.settings.types')[field.to_sym] || 'string'
      case type
      when 'boolean'
        ''.tap do |s|
          value = default if value.blank?
          s << "<div class='radios'>"
          s << radio_button_tag("settings[#{field}]", 'true', value == true, id: "settings_#{field}_true")
          s << label_tag("settings_#{field}_true", t("shoppe.settings.options.#{field}.affirmative", default: 'Yes'))
          s << radio_button_tag("settings[#{field}]", 'false', value == false, id: "settings_#{field}_false")
          s << label_tag("settings_#{field}_false", t("shoppe.settings.options.#{field}.negative", default: 'No'))
          s << '</div>'
        end.html_safe
      else
        text_field_tag "settings[#{field}]", value, options.merge(placeholder: default, class: 'text')
      end
    end

    def show_delivery_charges(order)
      order = Shoppe::Order.find(order.id)
      if order.delivery_charges > 0
        return number_to_currency order.delivery_charges
      else
        return "Free"
      end
    end

    def format_date(date)
      date.strftime("%b %d, %Y")
    end

    def format_datetime(date)
      date.strftime("%b %d, %Y at %I:%M %p")
    end

    def check_for_active(product)
      return product.name if product.active
      return "<strike>#{product.name}</strike>".html_safe
    end

    def check_for_default(product)
      return "<b>#{product.name}</b>".html_safe if product.default
      return product.name
      
    end

    def check_for_default_and_active(product)
      return check_for_default(product) if product.active
      return "<strike>#{check_for_default(product)}</strike>".html_safe

    end

  end
end
