class PreviewController < ApplicationController
  before_action :verify_admin

  def convert
    html_content = MarkdownService.new.render(params[:markdown_text])
    respond_to do |format|
      format.json{ render json: { html_content: html_content } }
    end
  end

end

