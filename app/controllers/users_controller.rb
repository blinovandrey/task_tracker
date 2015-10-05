class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin,   only: [:edit, :update, :destroy]

  def index
  	@users=User.all
  end

  def show
  	@selected_user=User.find(params[:id])
  	@projects=Project.all
  end

  def update
  	@selected_user = User.find(params[:id]) # find the foo
  @project = Project.find(params[:user][:projects]) # build new bar through foo
  @selected_user.projects << @project
  	redirect_to user_path
  end

private
  def admin
      @user = User.find(params[:id])
      redirect_to(user_path(@user)) unless current_user.admin?
    end

end