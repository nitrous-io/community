class ImageContentsController < ApplicationController
  before_action :verify_admin
  # TODO: Find a better solution to csrf authenticity token issue.
  skip_before_filter :verify_authenticity_token

  def create
    image = Image.new(file_name: params[:file])
    if image.save!
      respond_to do |format|
        format.json{ render json: image }
      end
    end
  end

end
