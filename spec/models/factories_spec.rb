require 'rails_helper'

FactoryGirl.factories.map(&:name).each do |factory_name|

  RSpec.describe factory_name.to_s.classify, :type => :model do

    context "with valid factory" do
      it { expect(build(factory_name)).to be_valid }
    end

    context "with invalid factory" do
      it { expect(build(factory_name, :invalid)).not_to be_valid }
    end

  end
      
end
