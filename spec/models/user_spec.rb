require 'rails_helper'

describe User do
  let(:user) { create(:user) }

  describe 'email_md5' do
    it 'gets set on save' do
      user.email = 'pete@nitrous.io'
      user.save
      expect(user.email_md5).to eq 'f8a2e702760da7ba4d9ddb49fb89432d'

      user.email = 'pete@action.io'
      user.save
      expect(user.email_md5).to eq 'b572d96ed32df51efbd4e96bb4ff50c0'
    end
  end


  describe '#gravatar' do
    it 'returns gravatar url' do
      user.email = 'pete@nitrous.io'
      user.save
      expect(user.gravatar(20)).to eq 'https://secure.gravatar.com/avatar/f8a2e702760da7ba4d9ddb49fb89432d?default=retro&secure=true&size=20'

      user.email = 'pete@action.io'
      user.save
      expect(user.gravatar(32)).to eq 'https://secure.gravatar.com/avatar/b572d96ed32df51efbd4e96bb4ff50c0?default=retro&secure=true&size=32'
    end
  end
end
