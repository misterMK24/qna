require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:rewards) { create_list(:reward, 2, user: user) }

  describe 'GET #index' do
    before do
      login(user)
      get :index
    end

    it 'return an array of existed rewards for current user' do
      expect(assigns(:rewards)).to match_array(rewards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
