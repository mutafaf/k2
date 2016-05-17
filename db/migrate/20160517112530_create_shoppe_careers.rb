class CreateShoppeCareers < ActiveRecord::Migration

  def self.up
    create_table :shoppe_careers do |t|
      t.integer :job_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :contact_no
      t.string :cnic_no
      t.datetime :date_of_birth
      t.string :gender
      t.string :martial_status
      t.string :mailing_address
      t.string :city
      t.string :highest_degree
      t.string :institute
      t.integer :year_of_completion
      t.string :gpa
      t.string :certification
      t.integer :relevant_experice
      t.string :designation
      t.string :organization
      t.string :address
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :shoppe_careers
  end

end
