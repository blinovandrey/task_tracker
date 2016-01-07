class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin, only: [:update]
  before_action :select_user, only: [:show, :update]

  def index
  	@users=User.all
  end

  def show
  	@projects=Project.all
  end

  def update
    @project = Project.find(params[:user][:projects])
    @selected_user.projects << @project
  	redirect_to user_path
  end

  private
    def admin
      @user = User.find(params[:id])
      redirect_to(user_path(@user)) unless current_user.admin?
    end

    def select_user
      @selected_user=User.find(params[:id])
    end

end