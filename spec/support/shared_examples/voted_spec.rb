require 'rails_helper'

shared_examples 'voted' do
  describe 'PATCH #vote_resource' do
    context 'when not author of these resource' do
      before do
        login(user)
        patch :vote_resource, params: { id: votable, count: 1, format: :json }
      end

      it 'rendering json response' do
        expect(response.headers['Content-Type']).to eq 'application/json; charset=utf-8'
        expect(response).to have_http_status(:ok)
      end

      it 'votes for the resource which has not been voted yet' do
        expect(votable.resource_rating).to be 1
      end

      it 'creates a new Vote record with the following attributes' do
        expect(Vote.last).to have_attributes(
          user: user,
          votable: votable
        )
      end
    end

    context 'when author of these resource' do
      before do
        login(votable.user)
        patch :vote_resource, params: { id: votable, count: 1, format: :json }
      end

      it 'gets an error' do
        expect(response.body).to include('User is author of this resource')
        expect(response.headers['Content-Type']).to eq 'application/json; charset=utf-8'
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when has already voted for these resource' do
      before do
        login(user)
        patch :vote_resource, params: { id: votable, count: 1, format: :json }
      end

      it 'gets an error' do
        patch :vote_resource, params: { id: votable, count: 1, format: :json }
        expect(response.body).to include('User has already voted')
        expect(response.headers['Content-Type']).to eq 'application/json; charset=utf-8'
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #vote_cancel' do
    before do
      login(user)
    end

    context 'when has already voted for these resource' do
      before do
        create(:vote, user: user, votable: votable)
      end

      it 'canceling a vote' do
        expect { delete :vote_cancel, params: { id: votable, format: :json } }.to change(Vote, :count).by(-1)
      end
    end

    context 'when has not voted for these resource yet' do
      before do
        delete :vote_cancel, params: { id: votable, format: :json }
      end

      it 'returns empty response' do
        expect(response).to have_http_status(:no_content)
        expect(response.body).to be_empty
      end
    end
  end
end
