require 'rails_helper'

describe "Main", type: :feature do
  describe 'User tests cards' do
    let!(:user) { create :user }
    let!(:deck) { create(:deck, user: user) }
    let!(:card) do
      card = create(:card, user: user, deck: deck, review_date: Date.today)
      card.update_attributes(review_date: Date.today.days_ago(3))
    end
    before do
      visit login_url
      # byebug
      fill_in 'Email', with: 'test@example.com'
      fill_in 'Password', with: 'foobar'
      click_button 'Log In'
    end
    it 'will return: Correct translation. Well done! if the translation is correct' do
      visit :dashboard
      fill_in 'Translation', with: 'Door'
      click_button 'Check'
      expect(page).to have_content 'Correct translation. Well done!'
    end
    it 'will return: Incorrect translation. Please review the word! if the translation is incorrect' do
      visit :dashboard
      fill_in 'Translation', with: 'Wrong'
      click_button 'Check'
      expect(page).to have_content 'Incorrect translation. Please review the word!'
    end
    it 'will return: Correct translation. Well done! if the user misspelled one character is correct' do
      visit :dashboard
      fill_in 'Translation', with: 'Dorr'
      click_button 'Check'
      expect(page).to have_content 'You were almost right!'
    end
  end
end
