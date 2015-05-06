require 'rails_helper'

RSpec.describe LikesController, type: :controller do

  describe "POST #create" do
    # TODO: Test success case.
    context "when logged in " do
      before { post :create }
      it { expect(response).to redirect_to(login_path) }
    end
  end

end
