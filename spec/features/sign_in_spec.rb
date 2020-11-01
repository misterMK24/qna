require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do

  given(:user) { create(:user) }

  background do
    # visit login page
    visit new_user_session_path
  end

  scenario 'Registered user tries to sign in' do
    fill_in 'Email',	with: user.email
    fill_in 'Password', with: user.password
    # универсальный хэлпер для нажатия на ссылки или кнопки
    click_on 'Log in'
    # при помощи гема launchy. открывает страницу перед тестом 
    # save_and_open_page

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email',	with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    # универсальный хэлпер для нажатия на ссылки или кнопки
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end

