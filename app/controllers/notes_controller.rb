class NotesController < ApplicationController

  # GET /notes
  def index
    @notes = @user.notes.page params[:page]
  end

  # GET /notes/:id
  def show
    @note = @user.notes.find params[:id]
    render layout: false
  end

  # PUT /notes/:id
  def update
    @note = @user.notes.find params[:id]
    @note.update_attributes params.require(:note).permit!
    redirect_back_or root_url
  end

  # DELETE /notes/:id
  def destroy
    @note = @user.notes.find params[:id]
    @note.destroy
    redirect_back_or root_url
  end

end
