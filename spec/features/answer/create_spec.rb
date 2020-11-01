require 'rails_helper'

feature 'User can create question', %q{
  In order to get an answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question_with_answers) }
  given(:answer) { create(:answer) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'user answers to a question with valid attribute' do
      fill_in 'Body', with: answer.body
      click_on 'Post'
      # save_and_open_page_wsl
      expect(page).to have_content answer.body
      expect(page).to have_xpath(".//div[@id='answers']/*", count: question.answers.length)
    end

    scenario 'user asks a question with errors' do
      click_on 'Post'
    
      expect(page).to have_content "Body can't be blank"
    end
  end

  # TODO: with Unauthenticated user. 



end
