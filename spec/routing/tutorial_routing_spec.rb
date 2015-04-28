require "rails_helper"

RSpec.describe TutorialsController, :type => :routing do
  describe "routing" do
    it { expect(:get => '/tutorial').to route_to('tutorials#new') }
    it { expect(:post => '/tutorial').to route_to('tutorials#create') }
    it { expect(:get => '/tutorials').to route_to('tutorials#index') }
  end
end
