require "rails_helper"

RSpec.describe TutorialsController, :type => :routing do
  describe "routing" do
    it { expect(get: '/tutorials/new').to route_to('tutorials#new') }
    it { expect(post: '/tutorials').to route_to('tutorials#create') }
    it { expect(get: '/tutorials').to route_to('tutorials#index') }
    it { expect(get: '/tutorial/this-is-a-slug').to route_to('tutorials#show', slug: "this-is-a-slug") }
  end
end
