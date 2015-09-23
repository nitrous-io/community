require 'rails_helper'

RSpec.describe PreviewController, type: :controller do

  describe "POST #convert" do
    before { sign_in_as_editor }
    before { xhr :post, :convert, markdown_text: "#header1" }
    it { expect(response).to have_http_status(:success) }
    it { expect(JSON.parse(response.body)).to include("html_content" => "<h1>header1</h1>\n") }
  end

end
