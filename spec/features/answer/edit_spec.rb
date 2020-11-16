require 'rails_helper'

feature 'User can edit an answer', %q{
  In order to have an opportunity
  to change the answer
  As an author of this answer
  I'd like to be able to edit the answer
} do

  describe 'Authenticated user', js: true do
    given(:answer) { create(:answer) }
    given(:user_with_answer) { answer.user }
    given(:question) { answer.question }

    context 'auhtor' do
      background do
        sign_in(user_with_answer)

        visit question_path(question)
        within('.answers') do
          click_link('Edit')
        end
      end

      scenario 'user edits an answer' do
        within('.answers') do
          fill_in 'Body', with: 'text text text'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'text text text'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'user edits an answer with errors' do
        within('.answers') do
          fill_in 'Body', with: ''
          click_on 'Save'
        end
        within('.answer-errors') do
          expect(page).to have_content "Body can't be blank"
        end
      end
    end
  
    context 'third person' do
      given(:user) { create(:user) }
      background { sign_in(user) }

      scenario 'third person edits an answer' do
        visit question_path(question)
        
        within('.answers') do
          expect(page).to have_no_link('Edit')
        end
      end
    end
  end
  
  describe 'Unauthenticated user' do
    given(:answer) { create(:answer) }
    given(:question) { answer.question }

    scenario 'Unanthenticated user tries to edit an answer' do
      visit question_path(question)

      within('.answers') do
        expect(page).to have_no_link('Edit')
      end
    end
  end
end
