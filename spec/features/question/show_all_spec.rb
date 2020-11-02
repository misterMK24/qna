require 'rails_helper'

feature 'User can see a list of questions', %q{
  In order to get a list of questions,
  user (no matter - is he registered or not) 
  should be able to see a list of all questions
} do

  # given(:user) { create(:user) }
  # 
  # background do
  #   sign_in(user)
  #   # visit questions_path
  # end

  describe 'wuth questions' do
    given!(:questions) { create_list(:question, 3) }
    
    scenario 'user gets a list of questions' do
      # save_and_open_page_wsl
      visit questions_path
      
      expect(page).to have_xpath(".//div[@id='questions']/*", count: questions.length) 
    end
  end

  describe 'wuthout questions' do
    scenario 'user do not get a list of questions' do
      visit questions_path

      expect(page).to have_xpath(".//div[@id='questions']/*", count: 0)
    end
  end
end
