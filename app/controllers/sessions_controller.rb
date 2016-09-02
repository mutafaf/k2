class SessionsController < Devise::SessionsController
  def create
    unless request.xhr?
      super
    end
  end

  def destroy
    super
  end
end