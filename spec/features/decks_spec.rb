require 'rails_helper'

describe "Decks", type: :feature do
  let!(:user) { create :user }
  before(:each) do
    visit login_url
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'foobar'
    click_button 'Log In'
  end

  describe '#new' do
    it 'will create a new deck' do
      visit new_deck_path
      fill_in 'Deck title', with: 'House'
      click_button 'Create deck'
      expect(page).to have_content 'Card deck House was created'
    end
  end
end
