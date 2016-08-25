require 'rails_helper'

describe "Decks", type: :feature do
  let!(:user) { create :user }
  before(:each) do
    visit login_url
    fill_in I18n.t('view.email'), with: user.email
    fill_in I18n.t('view.password'), with: 'foobar'
    click_button I18n.t('view.login_path')
  end

  describe '#new' do
    it 'will create a new deck' do
      visit new_deck_path
      fill_in I18n.t('view.deck_title'), with: 'House'
      click_button I18n.t('view.create_desk')
      expect(page).to have_content I18n.t('deck.success_create', deck: 'House')
    end
  end
end
