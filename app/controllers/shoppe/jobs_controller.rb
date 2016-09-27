class Shoppe::JobsController < Shoppe::ApplicationController
  before_filter { @active_nav = :jobs }
  before_filter :find_job, only: [:edit, :update, :destroy, :get_emails_by_job]

  def index
    @query = Shoppe::Job.all.page(params[:page]).search(params[:q])
    @jobs = @query.result
  end

  def new
    @job = Shoppe::Job.new
  end

  def create
    @job = Shoppe::Job.new(jobs_params)
     if @job.save
      redirect_to :jobs, flash: { notice: t('shoppe.jobs.created_successfully') }
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @job.update(jobs_params)
      redirect_to [:edit, @job], flash: { notice: t('shoppe.jobs.updated_successfully') }
    else
      render action: 'edit'
    end
  end

  def destroy
    @job.destroy
    redirect_to jobs_path, flash: { notice: t('shoppe.jobs.deleted_successfully') }
  end

  def get_emails_by_job
    @careers = @job.careers
  end

  private

  def jobs_params
    params[:job].permit(:name, :description, :position, :status)
  end

  def find_job
    @job = Shoppe::Job.find(params[:id])
  end

end
