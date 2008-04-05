class UsersController < ApplicationController
  skip_before_filter :login_required, :only=>[:new, :create]
  layout 'public'

  # GET /users/new
  def new
    @user = User.new
    set_captcha
  end

  # POST /users
  # Don't allow creation by XML
  def create
    @user = User.new(params[:user])
    if captcha_passed? and @user.save
      session[:user_id] = @user.id
      cookies[:user_id] = @user.id.to_s
      cookies[:password_hash] = @user.password_hash
      clear_captcha
      redirect_to home_path
    else
      @user.errors.add(:captcha, "does not add up") unless captcha_passed?
      @user.valid?
      set_captcha
      render :action=>'new'
    end
  end
  
  # GET /users/1/edit
  # No matter what ID is passed, user will only get themselves
  def edit
    @user = User.find(params[:id])
    redirect_to edit_user_path(current_user) and return unless @user == current_user
    render :layout=>'application'
  end
  
  # PUT /users/1
  # No matter what ID is passed, user will only get themselves
  def update
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Successfully updated.'
        format.html { redirect_to edit_user_url(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action=>'edit', :layout=>'application' }
        format.xml  { render :xml => @user.errors.to_xml }
      end
    end
  end
end
