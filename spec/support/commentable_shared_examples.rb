require 'rails_helper'

shared_examples 'commentable' do
  describe 'comment in session' do
    it 'sets comment with session value' do
      session[:comment] = { content_markdown: 'comment in session', parent_id: parent.id, parent_type: parent.class.name }
      do_request
      expect(assigns(:comment).content_markdown).to eq('comment in session')
      expect(session[:comment]).to be_nil
    end

    it 'does not set when parent is not matched' do
      session[:comment] = { content_markdown: 'comment in session', parent_id: parent.id + 1, parent_type: parent.class.name }
      do_request
      expect(assigns(:comment).content_markdown).to be_nil
      expect(session[:comment]).to be_nil
    end

    it 'does not set when session is not set' do
      do_request
      expect(assigns(:comment).content_markdown).to be_nil
      expect(session[:comment]).to be_nil
    end
  end
end