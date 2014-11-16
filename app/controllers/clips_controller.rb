class ClipsController < ApplicationController
  respond_to :json

  def show
    clip = Clip.find(params[:id])
    respond_with(clip) do |format|
      format.html { render 'home/index' }
    end
  end

  def create
  	clip = Clip.create(clip_params)
  	respond_with clip
  end

  def clip_params
  	params.permit(:end_time, :start_time, :video_id)
  end
end