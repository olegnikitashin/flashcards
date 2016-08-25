require 'rails_helper'

describe "Cards", type: :feature do
  let!(:deck) { create :deck }
  before(:each) do
    visit login_url
    fill_in I18n.t('view.email'), with: deck.user.email
    fill_in I18n.t('view.password'), with: 'foobar'
    click_button I18n.t('view.login_path')
  end

  describe '#new' do
    it 'will create card and upload an image' do
      visit new_card_path
      fill_in I18n.t('view.original_word'), with: 'Window'
      fill_in I18n.t('view.translation'), with: 'Окно'
      select deck.title, from: I18n.t('view.deck_card')
      attach_file(I18n.t('view.picture'), "#{Rails.root}/spec/fixtures/window.jpg")
      click_button I18n.t('view.create_card')
      expect(page).to have_css("img[src*='window.jpg']")
    end
  end
end
