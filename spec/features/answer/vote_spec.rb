require 'rails_helper'

feature 'User can vote for the answer', "
  As an not author of the answer
  I'd like to be able to vote for the answer" do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:vote) { create(:vote, votable: answer) }

  describe 'when authenticated user', js: true do
    given(:user) { create(:user) }

    before do
      sign_in(user)
      visit question_path(question)
    end

    context 'when votes' do
      scenario 'for the answer positively' do
        within(".answer[answer-id='#{answer.id}']") do
          click_link('Vote Up')
        end

        within('.answer_rating') do
          expect(page).to have_content 'Rating: 2'
        end
      end

      scenario 'for the answer negatively' do
        within(".answer[answer-id='#{answer.id}']") do
          click_link('Vote Down')
        end

        within('.answer_rating') do
          expect(page).to have_content 'Rating: 0'
        end
      end
    end

    context 'when canceling vote' do
      context 'without voting for these answer' do
        scenario 'does not changing rating of the answer' do
          within(".answer[answer-id='#{answer.id}']") do
            click_link('Cancel Vote')
          end

          within('.answer_rating') do
            expect(page).to have_content 'Rating: 1'
          end
        end
      end

      context 'when for the already voted answer' do
        before do
          within(".answer[answer-id='#{answer.id}']") do
            click_link('Vote Up')
          end
        end

        scenario 'changing rating of the answer' do
          within(".answer[answer-id='#{answer.id}']") do
            click_link('Cancel Vote')
          end

          within('.answer_rating') do
            expect(page).to have_content 'Rating: 1'
          end
        end
      end
    end
  end

  describe 'when unauthenticated user' do
    before do
      visit question_path(question)
    end

    scenario 'tries to vote for the answer' do
      within(".answer[answer-id='#{answer.id}']") do
        expect(page).to have_no_link('Vote Up')
        expect(page).to have_no_link('Vote Down')
      end
    end

    scenario 'tries to cancel vote for the answer' do
      within(".answer[answer-id='#{answer.id}']") do
        expect(page).to have_no_link('Cancel Vote')
      end
    end
  end
end
