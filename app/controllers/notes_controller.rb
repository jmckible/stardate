class NotesController < ApplicationController
  
  # GET /notes/:id
  def show
    @note = current_user.notes.find params[:id]
    render :layout=>false
  end
  
  # PUT /notes/:id
  def update
    @note = current_user.notes.find params[:id]
    @note.update_attributes params[:note]
    redirect_to root_url
  end
  
  # DELETE /notes/:id
  def destroy
    @note = current_user.notes.find params[:id]
    @note.destroy
    redirect_to root_url
  end
  
end
