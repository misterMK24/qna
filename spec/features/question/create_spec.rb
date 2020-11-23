require 'rails_helper'

feature 'User can create question', %q{
  In order to get an answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    context 'with valid attributes' do
      given(:url) { 'https://gist.github.com/' }

      background do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
      end

      scenario 'asks a questions' do
        click_on 'Ask'
  
        expect(page).to have_content 'Your quesion successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end

      scenario 'asks a question with attached files' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Ask'
  
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'asks a question with added links' do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: url
  
        click_on 'Ask'
  
        expect(page).to have_link 'My gist', href: url 
      end
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end  
  end
  
  scenario 'Unanthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
