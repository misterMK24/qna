require 'rails_helper'

feature 'User can edit question', "
  In order to have an opportunity
  to change the question
  As an author of this question
  I'd like to be able to edit the question
" do
  describe 'Authenticated user', js: true do
    given(:question) { create(:question) }
    given(:user_with_question) { question.user }
    given(:url1) { 'https://gist.github.com/' }
    # given(:url_2) { 'https://google.com/' }

    context 'when auhtor' do
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

      scenario 'edits a question with attached files' do
        within('.questions') do
          fill_in 'Title', with: 'new question title'
          fill_in 'Body', with: 'text text text'

          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
          expect(page).to have_link 'Edit'
        end
      end

      scenario 'edits a question with a link' do
        within('.questions') do
          fill_in 'Title', with: 'new question title'
          fill_in 'Body', with: 'text text text'

          click_on 'add link'

          within all('.nested-fields')[0] do
            fill_in 'Link name', with: 'gist link'
            fill_in 'Url', with: url1
          end

          click_on 'Save'

          expect(page).to have_link 'gist link', href: url1
        end
      end
    end

    context 'when third person' do
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
