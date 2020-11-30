require 'rails_helper'

feature 'User can sign up', "
  In order to ask questions
  As an unregistered user
  I'd like to be able to sign up
" do
  background { visit new_user_registration_path }

  scenario 'with valid attributes' do
    fill_in 'Email',	with: 'test@mail.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'

    within('.new_user') do
      click_on 'Sign up'
    end

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'without Email and password' do
    within('.new_user') do
      click_on 'Sign up'
    end

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end

  scenario 'with invlaid password length' do
    fill_in 'Email',	with: 'test@mail.com'
    fill_in 'Password', with: '123'
    fill_in 'Password confirmation', with: '123'

    within('.new_user') do
      click_on 'Sign up'
    end

    expect(page).to have_content 'Password is too short'
  end
end
