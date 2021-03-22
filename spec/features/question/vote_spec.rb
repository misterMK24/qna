require 'rails_helper'

feature 'User can vote for the question', "
  As an not author of the question
  I'd like to be able to vote for the question" do
  given!(:question) { create(:question) }
  given!(:vote) { create(:vote, votable: question) }

  describe 'when authenticated user', js: true do
    given(:user) { create(:user) }

    before do
      sign_in(user)
      visit question_path(question)
    end

    context 'when votes' do
      scenario 'for the question positively' do
        within('.questions') do
          click_link('Vote Up')
        end

        within('.question_rating') do
          expect(page).to have_content 'Rating: 2'
        end
      end

      scenario 'for the question negatively' do
        within('.questions') do
          click_link('Vote Down')
        end

        within('.question_rating') do
          expect(page).to have_content 'Rating: 0'
        end
      end
    end

    context 'when canceling vote' do
      context 'without voting for these question' do
        scenario 'does not changing rating of the question' do
          within('.questions') do
            click_link('Cancel Vote')
          end

          within('.question_rating') do
            expect(page).to have_content 'Rating: 1'
          end
        end
      end

      context 'when for the already voted question' do
        before do
          within('.questions') do
            click_link('Vote Up')
          end
        end

        scenario 'changing rating of the question' do
          within('.questions') do
            click_link('Cancel Vote')
          end

          within('.question_rating') do
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

    scenario 'tries to vote for the question' do
      within('.questions') do
        expect(page).to have_no_link('Vote Up')
        expect(page).to have_no_link('Vote Down')
      end
    end

    scenario 'tries to cancel vote for the question' do
      within('.questions') do
        expect(page).to have_no_link('Cancel Vote')
      end
    end
  end
end
