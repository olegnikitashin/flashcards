require 'rails_helper'

describe "User", type: :feature do
  describe 'User registration' do
    it 'will create a new user and log in' do
      visit signup_url
      fill_in I18n.t('users.form.email'), with: 'test@example.com'
      fill_in I18n.t('users.form.password'), with: 'foobar'
      fill_in I18n.t('users.form.password_confirmation'), with: 'foobar'
      click_button I18n.t('create_user')
      expect(page).to have_content I18n.t('home.form.all_cards_done')
    end
  end
end
