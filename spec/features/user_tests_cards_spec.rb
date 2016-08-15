require 'rails_helper'

describe "Main", type: :feature do
  describe 'User tests cards' do
    let!(:card) do
      user = create(:user)
      card = create(:card, user: user)
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
  end
end
