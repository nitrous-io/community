require 'rails_helper'

RSpec.describe ImageContentsController, type: :controller do

  let(:image) { create(:image) }
  let(:file) { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'mock-image.jpg')) }

  describe "POST create" do
    def do_request(params = {})
      xhr :post, :create, file: file
    end

    it_behaves_like 'an admin or editor only action'

    context "when logged in as admin" do
      before { sign_in_as_admin }

      it 'succeeds' do
        do_request
        expect(response).to have_http_status(:success)
      end

      it 'creates an image and returns' do
        expect { do_request }.to change(Image, :count).by(1)
        result = JSON.parse(response.body)
        image = Image.last
        expect(result['file_name']).to eq(image.as_json['file_name'])
      end

      context 'file is not valid' do
        let(:file) { nil }
        it 'returns 403' do
          do_request
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context "when logged in as editor" do
      before { sign_in_as_editor }

      it 'succeeds' do
        do_request
        expect(response).to have_http_status(:success)
      end

      it 'creates an image and returns' do
        expect { do_request }.to change(Image, :count).by(1)
        result = JSON.parse(response.body)
        image = Image.last
        expect(result['file_name']).to eq(image.as_json['file_name'])
      end

      context 'file is not valid' do
        let(:file) { nil }
        it 'returns 403' do
          do_request
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end
end
