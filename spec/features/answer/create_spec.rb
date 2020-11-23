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
      given(:url) { 'https://gist.github.com' }

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
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: url

        click_on 'Post'

        within(:xpath, ".//div[@answer-id='#{answer.id + 1}']") do
          expect(page).to have_link 'My gist', href: url  
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
