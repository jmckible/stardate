class WeightsController < ApplicationController

  # GET /weights/:id
  def show
    @weight = Current.user.weights.find params[:id]
    render layout: false
  end

  # PUT /weights/:id
  def update
    @weight = Current.user.weights.find params[:id]
    @weight.update params.expect(weight: [:date, :weight])
    redirect_back_or root_url
  end

  # DELETE /weights/:id
  def destroy
    @weight = Current.user.weights.find params[:id]
    @weight.destroy
    redirect_back_or root_url
  end

end
