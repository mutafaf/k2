class Shoppe::SubscribersController < Shoppe::ApplicationController

  before_filter { @active_nav = :subscribers }
  before_filter { params[:id] && @subscriber = Shoppe::Subscriber.find(params[:id]) }

  def index
    @query = Shoppe::Subscriber.all.page(params[:page]).search(params[:q])
    @subscribers = @query.result
  end

  def new
    @subscriber = Shoppe::Subscriber.new
  end

  def show
  end

  def create
    @subscriber = Shoppe::Subscriber.new(safe_params)
    if @subscriber.save
      redirect_to :subscribers, flash: { notice: t('shoppe.subscribers.created_successfully') }
    else
      render action: 'new'
    end
  end

  def update
    if @subscriber.update(safe_params)
      redirect_to [:edit, @subscriber], flash: { notice: t('shoppe.subscribers.updated_successfully') }
    else
      render action: 'edit'
    end
  end

  def destroy
    @subscriber.destroy
    redirect_to subscribers_path, flash: { notice: t('shoppe.subscribers.deleted_successfully') }
  end

  private

  def safe_params
    params[:subscriber].permit(:email, :contact_no)
  end
end
