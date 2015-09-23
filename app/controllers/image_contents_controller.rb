class ImageContentsController < ApplicationController
  before_action :verify_can_edit
  skip_before_filter :verify_authenticity_token, only: [:create]

  def create
    image = Image.new(file_name: params[:file])
    if image.save
      render json: image
    else
      render json: { message: image.errors.full_messages.join(',') }, status: :forbidden
    end
  end
end
