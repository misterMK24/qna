require 'rails_helper'

feature 'User can sign out', "
  In order to end user session
  As an authenticated user
  I'd like to be able to sign out
" do
  given(:user) { create(:user) }

  scenario 'user successfully sign out' do
    sign_in(user)
    click_on 'Sign Out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
