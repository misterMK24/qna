require 'rails_helper'

feature 'User can delete a link', "
  In order to delete a link
  for particular resource
  As an authenticated user
  and author of this resource
  I'd like to be able to delete a link
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, :with_answer, :with_link, user: user) }
  given!(:answer) { create(:answer, :with_link, user: user, question: question) }
  given!(:link) { question.links.first }

  describe 'Authenticated user', js: true do
    context 'when author' do
      background do
        sign_in(user)

        visit question_path(question)
      end

      scenario 'deletes a link from question' do
        within('.questions .links') do
          click_link 'delete'

          expect(page).to have_no_link link.name, href: link.url
        end
      end

      scenario 'deletes a link from answer' do
        within('.answers .links') do
          click_link 'delete'

          expect(page).to have_no_link link.name, href: link.url
        end
      end
    end

    context 'when third person' do
      given(:third_person) { create(:user) }

      background do
        sign_in(third_person)

        visit question_path(question)
      end

      scenario 'deletes a link from question' do
        within('.questions .links') do
          expect(page).to have_no_link('delete')
        end
      end

      scenario 'deletes a link from answer' do
        within(:xpath, ".//div[@answer-id='#{answer.id}']") do
          expect(page).to have_no_link('delete')
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    background { visit question_path(question) }

    scenario 'deletes a link from question' do
      within('.questions .links') do
        expect(page).to have_no_link('delete')
      end
    end

    scenario 'deletes a link from answer' do
      within(:xpath, ".//div[@answer-id='#{answer.id}']") do
        expect(page).to have_no_link('delete')
      end
    end
  end
end
