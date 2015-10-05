class PersonsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin

   def new
    @new_user = User.new
  end

  def create
    @new_user = User.new(user_params)
    if @new_user.save
    	@selected_user=@new_user
      redirect_to @selected_user
  else
  	render :new
  end
  end


 private

    def user_params
      params.require(:user).permit(:email, :password, :username, :admin)
    end

    def admin
      redirect_to(users_path) unless current_user.admin?
    end
end
