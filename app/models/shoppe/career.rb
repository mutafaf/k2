class Shoppe::Career < ActiveRecord::Base
  belongs_to :job

  has_many :attachments, as: :parent, dependent: :destroy, autosave: true, class_name: 'Shoppe::Attachment'

  GENDER = [['Male', 'Male'], ['Female', 'Female']]
  MARTIAL_STATUS = [['Martial Status', ''],['Single', 'Single'], ['Married', 'Married']]
  HIGHEST_DEGREE = [["Highest Degree", ""], ["Computer IT", "Computer IT"], ["Master", "Master"]]
  INSTITUE = [["Institute", ""], ["LUMS", "LUMS"], ["FAST", "FAST"], ["COMSATS", "COMSATS"]]
  YEAR_OF_COMPLETION = [["Year of Completion", ""], ["2000", "2000"], ["2001", "2001"]]
  RELEVANT_EXPERICE = [["Relevant Experice", ""], ["1", "1"], ["2", "2"]]
  DESIGNATION = [["Title / Designation", ""], ["LUMS", "LUMS"], ["FAST", "FAST"], ["COMSATS", "COMSATS"]]

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
