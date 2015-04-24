require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe "GET #home" do
    before { get :home }
    it { expect(response).to be_success }
  end

end
