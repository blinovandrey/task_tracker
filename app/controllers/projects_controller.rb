class ProjectsController < ApplicationController
before_action :authenticate_user!,   only: [:new, :create, :remove, :edit, :update, :destroy]
before_action :admin, only: [:new, :create, :remove, :edit, :update, :destroy]


include TasksHelper
def index
	@projects=Project.all
  end

 def new
 	@project=Project.new
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to  projects_path
    else
      render 'edit'
    end
  end

  def destroy
    @project = Project.find(params[:id]).destroy
    redirect_to  projects_path
  end


def show
    @project = Project.find(params[:id])
    @tasks = @project.tasks.all
    @sep = separate_by_state(@tasks)
    @tags=@tasks.tag_counts_on(:tags)
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
  @project = Project.find(params[:project_id])
  @selected_user.projects.delete(@project)
  redirect_to user_path
end 

def tagged
  @project = Project.find(params[:project_id])
  @tasks = @project.tasks.all
  @tags=@tasks.tag_counts_on(:tags)
  if params[:tag].present? 
    @tasks = @project.tasks.tagged_with(params[:tag])
  else 
    @tasks = @project.tasks.all
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

 end