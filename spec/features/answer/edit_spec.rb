require 'rails_helper'

feature 'User can edit an answer', %q{
  In order to have an opportunity
  to change the answer
  As an author of this answer
  I'd like to be able to edit the answer
} do

  describe 'Authenticated user' do
    given(:answer) { create(:answer) }
    given(:user_with_answer) { answer.user }
    given(:question) { answer.question }

    context 'auhtor' do
      background do
        sign_in(user_with_answer)

        visit question_path(question)
        click_on 'edit_answer'
      end

      scenario 'user edits an answer' do
        fill_in 'Body', with: 'text text text'
        click_on 'Save'

        expect(page).to have_content 'Answer has been updated successfully.'
        expect(page).to have_content 'text text text'
      end

      scenario 'user edits an answer with errors' do
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
      end
    end
  
    context 'third person' do
      given(:user) { create(:user) }
      background { sign_in(user) }

      scenario 'third person edits an answer through show page' do
        visit question_path(question)
        
        expect(page).to have_no_link('edit_answer')
      end

      scenario 'third person edits an answer through edit page' do
        visit edit_question_answer_path(answer, question_id: question)

        expect(page).to have_content 'You are not author of this answer'
      end
    end
  end
  
  describe 'Unauthenticated user' do
    given(:answer) { create(:answer) }
    given(:question) { answer.question }

    scenario 'Unanthenticated user tries to edit an answer' do
      visit question_path(question)

      expect(page).to have_no_link('edit_answer')
    end
  end
end
