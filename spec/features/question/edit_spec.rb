require 'rails_helper'

feature 'User can edit question', %q{
  In order to have an opportunity
  to change the question
  As an author of this question
  I'd like to be able to edit the question
} do

  describe 'Authenticated user', js: true do
    given(:question) { create(:question) }
    given(:user_with_question) { question.user }

    context 'auhtor' do
      background do
        sign_in(user_with_question)

        visit question_path(question)
        within('.questions') do
          click_on 'Edit'
        end
      end

      scenario 'user edits a question' do
        within('.questions') do
          fill_in 'Title', with: 'new question title'
          fill_in 'Body', with: 'text text text'
          click_on 'Save'

          expect(page).to have_content 'new question title'
          expect(page).to have_content 'text text text'
          expect(page).to have_link 'Edit'
        end
      end

      scenario 'user edits a question with errors' do
        within('.questions') do
          fill_in 'Body', with: ''
          click_on 'Save'

          expect(page).to have_content "Body can't be blank"
        end
      end
    end
  
    context 'third person' do
      given(:user) { create(:user) }
      background { sign_in(user) }

      scenario 'third person edits a question through show page' do
        visit question_path(question)
        
        within('.questions') do
          expect(page).to have_no_link('Edit')
        end
      end
    end
  end
  
  describe 'Unauthenticated user' do
    given(:question) { create(:question) }

    scenario 'Unanthenticated user tries to edit a question' do
      visit question_path(question)

      within('.questions') do
        expect(page).to have_no_link('Edit')
      end
    end
  end
end
