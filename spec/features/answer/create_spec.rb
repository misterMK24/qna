require 'rails_helper'

feature 'User can post an answer', %q{
  In order to give an answer 
  for particular question
  As an authenticated user
  I'd like to be able to post an answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, :with_answer, amount: 1) }
  given(:answer) { create(:answer) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'user answers to a question with valid attribute' do
      fill_in 'Body', with: answer.body
      click_on 'Post'

      expect(page).to have_content answer.body
      expect(page).to have_content 'Answer has been posted successfully'
    end

    scenario 'user answers to a question with errors' do
      click_on 'Post'
    
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unanthenticated user tries to answer to a question' do
    visit question_path(question)
    
    fill_in 'Body', with: answer.body
    click_on 'Post'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
