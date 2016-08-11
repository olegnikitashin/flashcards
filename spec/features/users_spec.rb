require 'rails_helper'

describe "User", type: :feature do
  describe 'User registration' do
    it 'will create a new user and log in' do
      visit signup_url
      fill_in 'Email', with: 'test@example.com'
      fill_in 'Password:', with: 'foobar'
      fill_in 'Password confirmation:', with: 'foobar'
      click_button 'Create'
      expect(page).to have_content 'All of the cards have been revised! Well done!'
    end
  end
end
