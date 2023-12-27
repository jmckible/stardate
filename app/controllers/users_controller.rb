class UsersController < ApplicationController

  # GET /users/:id/edit
  def edit
  end

  # PUT /users/:id
  def update
    Current.user.update! params.require(:user).permit(:name, :email, :time_zone, :password, :password_confirmation)
    redirect_to [:edit, Current.user]
  rescue ActiveRecord::RecordInvalid
    render action: 'edit'
  end

  # POST /users/:id/recur
  def recur
    Current.user.recurrings.on(Time.zone.today).each do |recurring|
      transaction = recurring.to_transaction
      transaction.save
    end
    redirect_to things_url
  end

end
