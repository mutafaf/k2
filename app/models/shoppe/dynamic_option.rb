require 'roo'
require 'globalize'

class Shoppe::DynamicOption < ActiveRecord::Base
  self.table_name = 'shoppe_dynamic_options'

   OPTIONS_FOR = ["Gender", "Marital Status", "Highest Degree", "Educational Board", "Certificate Programme", "University", "Province", "City"]

   scope :ordered, -> { order("created_at DESC") }

   validates :title, :options_for, presence: true


   def self.for(options_for)
     where(options_for: options_for)
   end

   def self.array_for(options_for)
     where(options_for: options_for).collect(&:title)
   end

   def self.import(file)
     spreadsheet = open_spreadsheet(file)
     spreadsheet.default_sheet = spreadsheet.sheets.first
     header = spreadsheet.row(1)
     (2..spreadsheet.last_row).each do |i|
       row = Hash[[header, spreadsheet.row(i)].transpose]

       # Don't import dynamic_options where the Title is blank
       next if row['Title'].nil?
       if dynamic_option = where(title: row['Title']).take
         # Dont import dynamic_options with the same Title
       else
         dynamic_option = new
         dynamic_option.title = row['Title']
         dynamic_option.options_for = row['Options For']
         dynamic_option.save!
       end
     end
   end

   def self.open_spreadsheet(file)
     case File.extname(file.original_filename)
     when '.csv' then Roo::CSV.new(file.path)
     when '.xls' then Roo::Excel.new(file.path)
     when '.xlsx' then Roo::Excelx.new(file.path)
     else fail I18n.t('shoppe.imports.errors.unknown_format', filename: File.original_filename)
     end
   end

end
