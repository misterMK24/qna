require 'rails_helper'

feature 'User can delete an attached file', %q{
  In order to delete an attachment 
  for particular resource
  As an authenticated user
  and author of this resource
  I'd like to be able to delete an attached files
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, :with_answer, :with_attachment, user: user) }
  given!(:answer) { create(:answer, :with_attachment, user: user, question: question) }

  describe "Authenticated user", js: true do
    context "author" do
      background do
        sign_in(user)
  
        visit question_path(question)
      end
      
      scenario 'deletes an attachment from question' do
        within('.questions .attached_files') do
          click_link 'delete'

          expect(page).to have_no_link('racecar.jpg')
        end
      end

      scenario 'deletes an attachment from answer' do
        within('.answers') do
          click_link 'delete'

          expect(page).to have_no_link('racecar.jpg')  
        end
      end
    end

    context "third person" do
      given(:third_person) { create(:user) }

      background do
        sign_in(third_person)
  
        visit question_path(question)
      end

      scenario 'deletes an attachment from question' do
        within('.questions .attached_files') do
          expect(page).to have_no_link('delete')  
        end
      end

      scenario 'deletes an attachment from answer' do
        within(:xpath, ".//div[@answer-id='#{answer.id}']") do
          expect(page).to have_no_link('delete')
        end
      end
    end
  end

  describe "Unauthenticated user" do
    background { visit question_path(question) }

    scenario 'deletes an attachment from question' do
      within('.questions .attached_files') do
        expect(page).to have_no_link('delete')  
      end
    end

    scenario 'deletes an attachment from answer' do
      within(:xpath, ".//div[@answer-id='#{answer.id}']") do
        expect(page).to have_no_link('delete')
      end
    end
  end
end

