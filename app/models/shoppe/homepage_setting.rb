class Shoppe::HomepageSetting < ActiveRecord::Base
  self.table_name = 'shoppe_homepage_settings'

  has_many :attachments, as: :parent, dependent: :destroy, class_name: 'Shoppe::Attachment'

  scope :slider_records, -> { where(setting_for: "Main Slider").order("position") }

  def attachments=(attrs)
    if attrs['image']['file'].present? then attachments.build(attrs['image']) end
  end

  def image
    attachments.for('image')
  end

  # Set attachment for the image role
  def image_file=(file)
    attachments.build(file: file, role: 'image')
  end

  # @return [Boolean]
  def is_logo?
    setting_for == "Logo"
  end
end
