class CareersController < ApplicationController

  def add_careers
    @career = Shoppe::Career.new(career_params)
    @career.save
    @career.attachments.create(file: params[:attachment])
    flash[:notice] = "Thank you for your interest."
    redirect_to "/careers"
  end

  private

  def career_params
    params[:date_of_birth] = params[:date_of_birth][:date_of_birth]
    params.permit(:job_id, :first_name, :last_name, :email, :contact_no, :cnic_no, :date_of_birth, :gender, :martial_status, :mailing_address, :city, :highest_degree, :institute, :year_of_completion, :gpa, :certification, :relevant_experice, :designation, :organization, :address)
  end

end
