require "rails_helper"

RSpec.describe SessionsController, :type => :routing do
  describe "routing" do
    it { expect(get:  '/login').to route_to('sessions#new') }
    it { expect(post: '/login').to route_to('sessions#create') }
    it { expect(delete: '/logout').to route_to('sessions#destroy') }
  end
end
