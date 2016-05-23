class CareersController < ApplicationController

  def add_careers
    @career = Shoppe::Career.new(career_params)
    @career.save
    flash[:notice] = "Thank you for your interest."
    redirect_to "/careers"
  end

  def careers
    @jobs = Shoppe::Job.all.enabled.order("position")
    @career = Shoppe::Career.new
  end

  private

  def career_params
    params[:career][:institute] = params[:other_institute] if params[:other_institute].present?
    file_params = [:file, :parent_id, :role, :parent_type, file: []]
    params[:career].permit(:job_id, :first_name, :last_name, :email, :contact_no, :cnic_no, :date_of_birth, :gender, :martial_status, :mailing_address, :city, :highest_degree, :institute, :year_of_completion, :gpa, :certification, :relevant_experice, :designation, :organization, :address, attachments: [default_image: file_params, data_sheet: file_params, extra: file_params])
  end

end
