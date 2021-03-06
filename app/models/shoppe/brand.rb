class Shoppe::Brand < ActiveRecord::Base

  has_many :attachments, as: :parent, dependent: :destroy, autosave: true, class_name: 'Shoppe::Attachment'
  validates :name, presence: true, uniqueness: true
  validates :permalink, presence: true, uniqueness: true, permalink: true

  before_validation { self.permalink = name.parameterize if permalink.blank? && name.is_a?(String) }


  def attachments=(attrs)
    if attrs['default_image']['file'].present? then attachments.build(attrs['default_image']) end
  end

  def default_image
    attachments.for('default_image')
  end

  def default_image_file=(file)
    attachments.build(file: file, role: 'default_image')
  end

end
