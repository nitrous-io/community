require "rails_helper"

RSpec.describe BlogsController, :type => :routing do
  describe "routing" do
    it { expect(get: '/blogs/new').to route_to('blogs#new') }
    it { expect(post: '/blogs').to route_to('blogs#create') }
    it { expect(get: '/blogs').to route_to('blogs#index') }
    it { expect(get: '/blog/this-is-a-slug').to route_to('blogs#show', slug: "this-is-a-slug") }
  end
end
