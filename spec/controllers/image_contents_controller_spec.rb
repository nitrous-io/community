require 'rails_helper'

RSpec.describe ImageContentsController, type: :controller do

  let!(:image) { create(:image) }

  describe "POST #create" do
    context "when logged in as admin" do
      before { session[:admin] = true }
      # FIXME: Error: ActiveRecord::RecordInvalid: Validation failed: File name can't be blank. 
      before { xhr :post, :create, image: attributes_for(:image) }
      it { expect(response).to have_http_status(:success) }
    end
    context "when not logged in as admin" do
      before { xhr :post, :create, image: attributes_for(:image) }
      it { expect(response).to redirect_to(root_path) }
    end
  end

end
