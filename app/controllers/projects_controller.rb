class ProjectsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :remove, :edit, :update, :destroy]
  before_action :admin, only: [:new, :create, :remove, :edit, :update, :destroy]
  before_action :set_project, only: [:edit, :update, :destroy, :show]
  before_action :set_project_id, only: [:remove, :tagged]
  before_action :set_tasks_all, only: [:show, :tagged] 

  include TasksHelper
  
  def index
	  @projects = Project.all
  end

  def new
 	  @project = Project.new
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to projects_path
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to  projects_path
  end


  def show
    @sep = separate_by_state(@tasks)
    @tags = @tasks.tag_counts_on(:tags)
  end


  def create
	  @project = current_user.projects.new(project_params)
    @project.creator = current_user
    @project.users << current_user
    if @project.save 
      redirect_to root_path
    else
      render :new
    end
  end

  def remove
    @selected_user = User.find(params[:id])
    @selected_user.projects.delete(@project)
    redirect_to user_path
  end 

  def tagged
    @tags = @tasks.tag_counts_on(:tags)
    if params[:tag].present? 
      @tasks = @project.tasks.tagged_with(params[:tag])
    end
    @sep = separate_by_state(@tasks)   
end

  private
    def project_params
      params.require(:project).permit(:title, :description, user_ids: [])
    end

    def admin
      redirect_to(projects_path) unless current_user.admin?
    end

    def set_project
      @project = Project.find(params[:id])
    end

    def set_project_id
      @project = Project.find(params[:project_id])
    end

    def set_tasks_all
      @tasks = @project.tasks.all
    end

 end