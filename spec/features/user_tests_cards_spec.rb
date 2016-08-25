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
      fill_in I18n.t('user_sessions.form.email'), with: 'test@example.com'
      fill_in I18n.t('user_sessions.form.password'), with: 'foobar'
      click_button I18n.t('user_sessions.form.login_path')
    end
    it 'will return: Correct translation. Well done! if the translation is correct' do
      visit :dashboard
      fill_in I18n.t('home.form.translation'), with: 'Door'
      click_button I18n.t('home.form.check')
      expect(page).to have_content I18n.t('home.check_card.correct')
    end
    it 'will return: Incorrect translation. Please review the word! if the translation is incorrect' do
      visit :dashboard
      fill_in I18n.t('home.form.translation'), with: 'Wrong'
      click_button I18n.t('home.form.check')
      expect(page).to have_content I18n.t('home.check_card.incorrect')
    end
    it 'will return: Correct translation. Well done! if the user misspelled one character is correct' do
      visit :dashboard
      fill_in I18n.t('home.form.translation'), with: 'Dorr'
      click_button I18n.t('home.form.check')
      expect(page).to have_content I18n.t('home.check_card.misspelled', input: 'Dorr', original: 'Door')
    end
  end
end
