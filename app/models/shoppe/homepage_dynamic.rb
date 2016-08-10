class Shoppe::HomepageDynamic < ActiveRecord::Base
  self.table_name = 'shoppe_homepage_dynamics'

  has_many :attachments, as: :parent, dependent: :destroy, class_name: 'Shoppe::Attachment'



  def attachments=(attrs)

    if attrs['default_image']['file'].present? then attachments.build(attrs['default_image']) end
    if attrs['extra']['file'].present? then attrs['extra']['file'].each { |attr| attachments.build(file: attr, parent_id: attrs['extra']['parent_id'], parent_type: attrs['extra']['parent_type']) } end

    if attrs['logo_image']['file'].present? then attachments.build(attrs['logo_image']) end
  end

  def default_image
    attachments.for('default_image')
  end

  # Set attachment for the default_image role
  def default_image_file=(file)
    attachments.build(file: file, role: 'default_image')
  end

  def logo_image
    attachments.for('logo_image')
  end

  # Set attachment for the logo_image role
  def logo_image_file=(file)
    attachments.build(file: file, role: 'logo_image')
  end

end
