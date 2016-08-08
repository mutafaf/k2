class Shoppe::CareersController < Shoppe::ApplicationController


  def show
    @career = Shoppe::Career.find(params[:id])
    url = @career.attachments.try(:first).try(:file).try(:url)
    path =  Rails.root.join("public/#{url}")
    @file_exist =  File.exists?(path) ?  true : false
  end

end
