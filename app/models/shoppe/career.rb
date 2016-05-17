class Shoppe::Career < ActiveRecord::Base
  belongs_to :job

  has_many :attachments, as: :parent, dependent: :destroy, autosave: true, class_name: 'Shoppe::Attachment'

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
