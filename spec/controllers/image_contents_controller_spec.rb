require 'rails_helper'

RSpec.describe ImageContentsController, type: :controller do

  let(:image) { create(:image) }
  let(:file) { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'mock-image.jpg')) }

  describe "POST #create" do
    def do_request
      xhr :post, :create, file: file
    end

    context "when logged in as admin" do
      before { session[:admin] = true }
      # FIXME: Error: ActiveRecord::RecordInvalid: Validation failed: File name can't be blank.

      it do
        do_request
        expect(response).to have_http_status(:success)
      end
    end
    context "when not logged in as admin" do
      it do
        do_request
        expect(response).to redirect_to(root_path)
      end
    end
  end

end
