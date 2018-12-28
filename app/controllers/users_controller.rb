class UsersController < ApplicationController

  # GET /users/:id/edit
  def edit
  end

  # PUT /users/:id
  def update
    @user.update! params.require(:user).permit(:name, :email, :time_zone, :password, :password_confirmation)
    redirect_to [:edit, @user]
  rescue ActiveRecord::RecordInvalid
    render action: 'edit'
  end

end
