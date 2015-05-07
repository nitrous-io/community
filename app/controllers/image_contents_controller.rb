class ImageContentsController < ApplicationController
  before_action :verify_admin

  def create
    image = Image.new(file_name: params[:file])
    if image.save!
      respond_to do |format|
        format.json{ render :json => image }
      end
    end
  end

end
