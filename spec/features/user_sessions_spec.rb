require 'rails_helper'

describe "User Sessions", type: :feature do
  let!(:user) { create :user }
  describe '#create' do
    it 'will Log In a user' do
      visit login_url
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'foobar'
      click_button 'Log In'
      expect(page).to have_content 'All of the cards have been revised! Well done!'
    end
    it 'will not Log In a user with wrong password' do
      visit login_url
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'foobar1'
      click_button 'Log In'
      expect(page).to have_content 'Login failed!'
    end
  end
  describe '#destroy' do
    before do
      visit login_url
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'foobar'
      click_button 'Log In'
    end
    it 'will Log Out a user' do
      visit root_path
      click_link 'Logout'
      expect(page).to have_content 'Logged out!'
    end
  end
  describe 'Restricted access' do
    it 'will prevent from getting access without login' do
      paths = [cards_path, new_card_path]
      paths.each do |path|
        visit path
        expect(page).to have_content 'You can Login or Signup to start learning new words!'
      end
    end
  end
end
