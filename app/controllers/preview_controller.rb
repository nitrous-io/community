class PreviewController < ApplicationController

  def convert
    html_content = MarkdownService.new.convert_to_html(params[:markdown_text])
    respond_to do |format|
      format.json{ render json: { html_content: html_content } }
    end
  end

end

