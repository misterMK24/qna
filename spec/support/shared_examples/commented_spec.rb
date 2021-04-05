require 'rails_helper'

shared_examples 'commented' do
  describe 'POST #create_comment', js: true do
    before { login(user) }

    it 'creates new Comment' do
      expect { post :create_comment, params: { id: commentable.id, comment: { body: 'comment for the question' }, format: 'js' } }.to change(Comment, :count).by(1)
    end

    it 'creates new Comment with the following attributes' do
      post :create_comment, params: { id: commentable.id, comment: { body: 'comment for the question' }, format: 'js' }

      expect(Comment.last).to have_attributes(
        user: user,
        commentable: commentable
      )
    end
  end

  describe 'DELETE #destroy_comment' do
    let!(:comment) { create(:comment, commentable: commentable) }

    before do
      login(user)
    end

    it 'deletes a comment' do
      expect { delete :destroy_comment, params: { id: comment.id, format: 'js' } }.to change(Comment, :count).by(-1)
    end
  end
end
