require 'rails_helper'

feature 'User can see a particular question', %q{
  In order to get a question page,
  user (no matter - is he registered or not) 
  should be able to see a question page
} do

  background { visit question_path(question) }

  describe 'with answers' do
    given!(:question) { create(:question, :with_answer, amount: 1) }

    scenario 'user gets a question page with answers' do
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)  
      expect(page).to have_xpath(".//div[@id='answers']/*", count: question.answers.length)
    end
  end

  describe 'without answers' do
    given!(:question) { create(:question) }

    scenario 'user gets a question page without answers' do
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)  
      expect(page).to have_xpath(".//div[@id='answers']/*", count: 0)
    end
  end
end
