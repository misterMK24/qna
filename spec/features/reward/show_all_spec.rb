require 'rails_helper'

feature 'User can see a list of his rewards', %q{
  In order to get a list of rewards,
  user should be able to see a list of his rewards
} do

  describe 'wuth rewards' do
    given!(:user) { create(:user) }
    given!(:rewards) { create_list(:reward, 2, user: user) }

    scenario 'gets a list of rewards' do
      sign_in(user)
      visit rewards_index_path

      expect(page).to have_xpath(".//div[@class='card']", count: rewards.length) 
    end
  end

  describe 'wuthout rewards' do
    given(:user_without_rewards) { create(:user) }

    scenario 'user do not get a list of questions' do
      sign_in(user_without_rewards)
      visit rewards_index_path

      expect(page).to have_xpath(".//div[@class='card']", count: 0)
    end
  end
end
