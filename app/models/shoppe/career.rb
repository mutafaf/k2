class Shoppe::Career < ActiveRecord::Base
  belongs_to :job

  has_many :attachments, as: :parent, dependent: :destroy, autosave: true, class_name: 'Shoppe::Attachment'

  GENDER = ["Male", "Female", "Other"]
  MARTIAL_STATUS = ["Single", "Married", "Widow/Widower"]
  YEAR_OF_COMPLETION = (1950..2016).to_a.reverse
  RELEVANT_EXPERICE = (0..50).to_a

  HIGHEST_DEGREE = "Highest Degree"
  INSTITUE = "Institute"
  DESIGNATION = "Designation"
  CITY = "City"

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
