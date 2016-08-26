require 'rails_helper'

describe "Cards", type: :feature do
  let!(:deck) { create :deck }
  before(:each) do
    visit login_url
    fill_in I18n.t('user_sessions.form.email'), with: deck.user.email
    fill_in I18n.t('user_sessions.form.password'), with: 'foobar'
    click_button I18n.t('user_sessions.form.login_path')
  end

  describe '#new' do
    it 'will create card and upload an image' do
      visit new_card_path
      fill_in I18n.t('cards.form.original_word'), with: 'Window'
      fill_in I18n.t('cards.form.translation'), with: 'Окно'
      select deck.title, from: I18n.t('deck_card')
      attach_file(I18n.t('cards.form.picture'), "#{Rails.root}/spec/fixtures/window.jpg")
      click_button I18n.t('cards.form.create_card')
      expect(page).to have_css("img[src*='window.jpg']")
    end
  end
end
