class UsersController < ApplicationController

  # GET /users/:id/edit
  def edit
    @user = current_user
  end
  
  # PUT /users/:id
  def update
    @user = current_user
    @user.update_attributes! params[:user]
    redirect_to edit_user_url(@user)
  rescue ActiveRecord::RecordInvalid
    render :action=>:edit
  end

end
