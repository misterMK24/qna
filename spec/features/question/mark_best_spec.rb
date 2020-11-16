require 'rails_helper'

feature 'Question author can mark bset answer', %q{
  As an author of question
  I'd like to be able to mark one of
  answers as the best
} do

  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, body: "Best", question: question) }

  describe 'Authenticated user', js: true do
    context 'auhtor' do
      given!(:user_with_question) { question.user }

      scenario 'user marks answer as the best' do
        sign_in(user_with_question)
        visit question_path(question)

        within(:xpath, ".//div[@answer-id='#{answer.id}']") do
          click_link('Best')
        end

        within('.best_answer') do
          expect(page).to have_content answer.body
        end
      end
    end
  
    context 'third person' do
      given(:user) { create(:user) }

      scenario 'third person marks answer as the best' do
        sign_in(user)
        visit question_path(question)
        
        within('.answers') do
          expect(page).to have_no_link('Best')
        end
      end
    end
  end
  
  describe 'Unauthenticated user' do
    scenario 'tries to choose the best answer' do
      visit question_path(question)

      within('.answers' ) do
        expect(page).to have_no_link('Best')
      end
    end
  end
end
