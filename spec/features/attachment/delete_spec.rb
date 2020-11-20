require 'rails_helper'

feature 'User can delete an attached file', %q{
  In order to delete an attachment 
  for particular resource
  As an authenticated user
  and author of this resource
  I'd like to be able to delete an attached files
} do

  describe "Authenticated user", js: true do
    given(:user) { create(:user) }
    given!(:question) { create(:question, :with_answer, :with_attachment, user: user) }
    given!(:answer) { create(:answer, user: user, question: question) }
    
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

      scenario 'deletes an attachment from answer'
    end

    context "third person" do
      
    end
  end

  describe "Unauthenticated user" do
    
  end
  
end

