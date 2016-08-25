require 'rails_helper'

describe "User Sessions", type: :feature do
  let!(:user) { create :user }
  describe '#create' do
    it 'will Log In a user' do
      visit login_url
      fill_in I18n.t('view.email'), with: user.email
      fill_in I18n.t('view.password'), with: 'foobar'
      click_button I18n.t('view.login_path')
      expect(page).to have_content I18n.t('view.all_cards_done')
    end
    it 'will not Log In a user with wrong password' do
      visit login_url
      fill_in I18n.t('view.email'), with: user.email
      fill_in I18n.t('view.password'), with: 'foobar1'
      click_button I18n.t('view.login_path')
      expect(page).to have_content I18n.t('user_sess.login_failed')
    end
  end
  describe '#destroy' do
    before do
      visit login_url
      fill_in I18n.t('view.email'), with: user.email
      fill_in I18n.t('view.password'), with: 'foobar'
      click_button I18n.t('view.login_path')
    end
    it 'will Log Out a user' do
      visit root_path
      click_link I18n.t('view.logout_path')
      expect(page).to have_content I18n.t('user_sess.logout_success')
    end
  end
  describe 'Restricted access' do
    it 'will prevent from getting access without login' do
      paths = [cards_path, new_card_path]
      paths.each do |path|
        visit path
        expect(page).to have_content I18n.t('view.welcome_message')
      end
    end
  end
end
