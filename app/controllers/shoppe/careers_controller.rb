class Shoppe::CareersController < Shoppe::ApplicationController


  def show
    @career = Shoppe::Career.find(params[:id])
  end

end
