require 'rails_helper'

feature 'User can delete a question', %q{
  In order to delete a question
  As an authenticated user
  and author of this question
  I'd like to be able to delete a question
} do

  given(:user_with_questions) { create(:user, :with_question, amount: 1) }
  given(:question) { user_with_questions.questions.first }

  describe 'Authenticated user' do    
    context 'author' do
      scenario 'author of question tries to delete an question' do
        sign_in(user_with_questions)
        visit question_path(question)
        within('.questions') do
          click_on 'Delete'
        end

        expect(page).to have_content 'Question has been successfully deleted'
      end
    end
    
    context 'third person' do
      given(:user) { create(:user) }

      scenario 'third person tries to delete an question' do
        sign_in(user)
        visit question_path(question)

        expect(page).to have_no_link('delete_question')
      end
    end
  end

  scenario 'Unauthenticated user tries to delete an question' do
    visit question_path(question)
    within('.questions') do
      expect(page).to have_no_link('Delete')
    end
  end
end
