require 'rails_helper'

feature 'User can edit question', %q{
  In order to have an opportunity
  to change the question
  As an author of this question
  I'd like to be able to edit the question
} do

  describe 'Authenticated user' do
    given(:user_with_question) { create(:user, :with_question, amount: 1) }
    given(:question) { user_with_question.questions.first }

    context 'auhtor' do
      background do
        sign_in(user_with_question)

        visit question_path(question)
        click_on 'edit_question'
      end

      scenario 'user edits a question' do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
        click_on 'Save'

        expect(page).to have_content 'Your quesion has been successfully updated.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end

      scenario 'user edits a question with errors' do
        fill_in 'Title', with: ''
        click_on 'Save'

        expect(page).to have_content "Title can't be blank"
      end
    end
  
    context 'third person' do
      given(:user) { create(:user) }
      background { sign_in(user) }

      scenario 'third person edits a question through show page' do
        visit question_path(question)
        
        expect(page).to have_no_link('edit_question')
      end

      scenario 'third person edits a question through edit page' do
        visit edit_question_path(question)

        expect(page).to have_content 'You are not author of this question'
      end
    end
  end
  
  describe 'Unauthenticated user' do
    given(:question) { create(:question) }

    scenario 'Unanthenticated user tries to edit a question' do
      visit question_path(question)

      expect(page).to have_no_link('edit_question')
    end
  end
end
