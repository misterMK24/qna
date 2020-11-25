require 'rails_helper'

feature 'User can post an answer', %q{
  In order to give an answer 
  for particular question
  As an authenticated user
  I'd like to be able to post an answer
} do

  given!(:question) { create(:question, :with_answer, amount: 1) }

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    context 'with valid attributes' do
      given!(:answer) { create(:answer) }
      given(:url_1) { 'https://gist.github.com' }
      given(:url_2) { 'https://google.com' }

      background { fill_in 'Body', with: answer.body }
      
      scenario 'answers to a question with valid attribute' do
        click_on 'Post'

        expect(page).to have_css('.answers', count: question.answers.length)
      end

      scenario 'answers to a question with attached files' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Post'

        within(:xpath, ".//div[@answer-id='#{answer.id + 1}']") do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'answers to a question with added link' do
        within all('.nested-fields')[0] do
          fill_in 'Link name', with: 'gist link'
          fill_in 'Url', with: url_1
        end

        within('.answer_links') do
          click_on 'add link'
        end

        within all('.nested-fields')[1] do
          fill_in 'Link name', with: 'google link'
          fill_in 'Url', with: url_2
        end

        click_on 'Post'

        within(:xpath, ".//div[@answer-id='#{answer.id + 1}']") do
          expect(page).to have_link 'gist link', href: url_1
          expect(page).to have_link 'google link', href: url_2
        end      
      end
    end

    scenario 'answers to a question with errors' do
      click_on 'Post'
    
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unanthenticated user tries to answer to a question' do
    visit question_path(question)

    expect(page).to have_no_link('Post')
  end
end
