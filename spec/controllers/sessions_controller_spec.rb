require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET new" do
    before { get :new }
    it { is_expected.to render_template(:new) }
    it { expect(response).to be_success }
  end

#  # FIXME: Test not passing.
#  describe "POST create" do
#    context "with valid params" do
#      before { post :create, user: {username_or_email: "bighero", password: "baymaxxy"} }
#      it { expect(response).to be_success }
#    end
#    context "with invalid params" do
#      before { post :create, user: {username_or_email: "fakehero", password: "fakepw"} }
#      it { expect(response).not_to be_success }
#    end
#  end
#
#  describe "DELETE destroy" do
#    # TODO: Implement success case.
#    before { delete :destroy }
#      it { expect(response).not_to be_success }
#  end

end
