require 'rails_helper'

describe "Cards", type: :feature do
  let!(:deck) { create :deck }
  before(:each) do
    visit login_url
    fill_in 'Email', with: deck.user.email
    fill_in 'Password', with: 'foobar'
    click_button 'Log In'
  end

  describe '#new' do
    it 'will create card and upload an image' do
      visit new_card_path
      fill_in 'Original word', with: 'Window'
      fill_in 'Translation', with: 'Окно'
      select deck.title, from: 'Deck'
      attach_file('Card picture', "#{Rails.root}/spec/fixtures/window.jpg")
      click_button 'Create card'
      expect(page).to have_css("img[src*='window.jpg']")
    end
  end
end
