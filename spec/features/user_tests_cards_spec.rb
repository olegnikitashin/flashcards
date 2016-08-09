require 'rails_helper'

describe "Main", type: :feature do
  describe 'User tests cards' do
    let!(:card) { create(:card) }
    it 'will return: Correct translation. Well done! if the translation is correct' do
      visit root_path
      fill_in 'input_text', with: 'Door'
      click_button 'Check'

      expect(page).to have_content 'Correct translation. Well done!'
    end
    it 'will return: Incorrect translation. Please review the word! if the translation is incorrect' do
      visit root_path
      fill_in 'input_text', with: 'wrong'
      click_button 'Check'
      expect(page).to have_content 'Incorrect translation. Please review the word!'
    end
  end
end
