module ApplicationHelper
	def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user=@user
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
