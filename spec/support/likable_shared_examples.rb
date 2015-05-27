require 'rails_helper'

shared_examples 'likable' do
  describe 'upvote' do
    it 'updates score' do
      expect { subject.upvote(user.id) }.to change { subject.reload.score }.by(1)
    end

    it 'creates like' do
      expect { subject.upvote(user.id) }.to change(Like, :count).by(1)
    end

    it 'returns true' do
      expect(subject.upvote(user.id)).to eq(true)
    end

    context 'when fails to update' do
      it 'returns false' do
        expect {
          expect(subject.upvote(nil)).to eq(false)
        }.not_to change(Like, :count)
      end
    end
  end

  describe 'is_upvoted_by' do
    it 'return false when the post is not upvoted by user' do
      expect(subject.is_upvoted_by?(user.id)).to eq(false)
    end

    it 'return true when the post has been upvoted by user' do
      create(:like, parent: subject, user: user)
      expect(subject.is_upvoted_by?(user.id)).to eq(true)
    end
  end
end