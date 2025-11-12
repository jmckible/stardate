class NotesController < ApplicationController

  # GET /notes
  def index
    @notes = Current.user.notes.page params[:page]
  end

  # GET /notes/:id
  def show
    @note = Current.user.notes.find params[:id]
    render layout: false
  end

  # PUT /notes/:id
  def update
    @note = Current.user.notes.find params[:id]
    @note.update params.expect(note: [:date, :body])
    redirect_back_or root_url
  end

  # DELETE /notes/:id
  def destroy
    @note = Current.user.notes.find params[:id]
    @note.destroy
    redirect_back_or root_url
  end

end
