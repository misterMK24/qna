require 'rails_helper'

feature 'User can see a list of questions', %q{
  In order to get a list of questions,
  user (no matter - is he registered or not) 
  should be able to see a list of all questions
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question_with_answers, 3) }

  background { sign_in(user) }

  scenario 'user gets a list of questions' do
    visit questions_path
    
    expect(page).to have_xpath(".//div[@id='questions']/*", count: questions.length) 
  end

  # TODO: create new file spec for the spec below
  scenario 'user get a question page with answers' do
    visit question_path(questions.first)

    expect(page).to have_content(questions.first.title)
    expect(page).to have_content(questions.first.body)  
    expect(page).to have_xpath(".//div[@id='answers']/*", count: questions.first.answers.length)
  end
end
