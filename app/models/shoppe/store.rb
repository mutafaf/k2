require 'roo'
require 'globalize'

class Shoppe::Store < ActiveRecord::Base
  self.table_name = 'shoppe_stores'

  # reverse_geocoded_by :lat, :lng

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    spreadsheet.default_sheet = spreadsheet.sheets.first
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]

      # Don't import stores where the name is blank
      next if row['Name'].nil?
      if store = where(name: row['Name']).take
        # Dont import stores with the same name
      else
        store = new
        store_no = row['Store No'].to_i
        store.store_no = store_no
        store.name = row['Name']
        store.city = row['City']
        store.phone_number = row['Phone Number']
        store.save!
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
