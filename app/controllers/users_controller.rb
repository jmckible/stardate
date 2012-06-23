class UsersController < ApplicationController

  # GET /users/:id/edit
  def edit
  end
  
  # PUT /users/:id
  def update
    @user.update_attributes! params[:user]
    redirect_to edit_user_url(@user)
  rescue ActiveRecord::RecordInvalid
    render action: 'edit'
  end

end
