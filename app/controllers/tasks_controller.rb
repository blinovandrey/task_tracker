class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :creator_executor_or_admin,   only: [:edit, :update, :destroy]
  before_action :project_user, only: [:new, :create]
	def index
    @project = Project.find(params[:project_id])
    @tasks = @project.tasks.all
  	end

  	def new
    @project = Project.find(params[:project_id])
    @task = @project.tasks.new
    @creator = current_user
  end

  def create
  	@project = Project.find(params[:project_id])
    @task = @project.tasks.new(task_params)
    @task.creator = current_user
    @task.users << current_user
    @task.users << @task.executor
    if @task.save
      redirect_to project_path(params[:project_id])
    else
      render :new
    end
  end

   def show
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:id])
    @creator = @task.creator
    @executor = @task.executor
  end

  def edit
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:id])
    @creator = @task.creator
  end

  def update
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:id])

    if @task.update(task_params)
      redirect_to  project_path(@project)
    else
      render 'edit'
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:id]).destroy
    redirect_to  project_path(@project)
  end


private

    def task_params
    params.require(:task).permit(:title, :state_event, :description, :creator_id, :executor_id, :tag_list)
  end

  def creator_executor_or_admin
      @project = Project.find(params[:project_id])
      @task = @project.tasks.find(params[:id])
      @creator = @task.creator
      @executor = @task.executor

      redirect_to(project_task_path(@project,@task)) unless current_user==@creator || current_user==@executor || current_user.admin?
    end

  def project_user
      @project = Project.find(params[:project_id])
      redirect_to project_path(@project) unless @project.users.include?(current_user)
    end

end