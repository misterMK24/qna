require 'rails_helper'

feature 'User can delete an answer', %q{
  In order to delete an answer 
  for particular question
  As an authenticated user
  and author of this answer
  I'd like to be able to delete an answer
} do

  given(:answer) { create(:answer) }
  given(:user) { answer.user }
  given(:question) { answer.question }

  describe 'Authenticated user', js: true do
    context 'author' do
      scenario 'tries to delete an answer' do
        sign_in(user)
        visit question_path(question)

        within('.answers') do
          click_on 'Delete'
        
          expect(page).to_not have_content answer.body
        end
      end
    end

    context 'third person' do
      given(:user) { create(:user) }

      scenario 'third person tries to delete an answer' do
        sign_in(user)
        visit question_path(question)

        within('.answers') do
          expect(page).to have_no_link('Delete')
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to delete an answer' do
    visit question_path(question)

    within('.answers') do
      expect(page).to have_no_link('Delete')
    end
  end
end
