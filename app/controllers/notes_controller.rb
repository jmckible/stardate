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
    @note.update params.require(:note).permit(:date, :body)
    redirect_back_or root_url
  end

  # DELETE /notes/:id
  def destroy
    @note = @user.notes.find params[:id]
    @note.destroy
    redirect_back_or root_url
  end

end
