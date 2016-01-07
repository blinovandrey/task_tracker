class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_task_creator, only: [:show, :edit]
  before_action :creator_executor_or_admin,   only: [:edit, :update, :destroy]
  before_action :project_user, only: [:new, :create]

	def index
    @tasks = @project.tasks.all
  	end

  	def new
    @task = @project.tasks.new
    @creator = current_user
  end

  def create
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
    @executor = @task.executor
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to  project_path(@project)
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to  project_path(@project)
  end


  private
    def task_params
      params.require(:task).permit(:title, :state_event, :description, :creator_id, :executor_id, :tag_list)
    end

    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_task
      @task = @project.tasks.find(params[:id])
    end

    def set_task_creator
      @creator = @task.creator
    end

    def creator_executor_or_admin
      @executor = @task.executor
      redirect_to(project_task_path(@project,@task)) unless current_user==@creator || current_user==@executor || current_user.admin?
    end

    def project_user
      redirect_to project_path(@project) unless @project.users.include?(current_user) || current_user.admin?
    end

end