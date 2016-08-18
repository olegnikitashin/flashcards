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

  describe '#set_review_date' do
    let(:user) { create :user }
    let(:deck) { create(:deck, user: user) }
    let(:card) { create(:card, deck: deck, user: user) }
    revisions_hours = { 0 => 0, 1 => 12 }
    revisions_hours.each_pair do |revisions, hrs|
      it 'will increase review_date according to revisions number' do
        card.update(revisions: revisions)
        expect(card.review_date).to eq Date.today + hrs.hours
      end
    end
    revisions_days = {
      2 => 3,
      3 => 7,
      4 => 14,
      5 => 30,
      6 => 90
    }
    revisions_days.each_pair do |revisions, dys|
      it 'will increase review_date according to revisions number' do
        card.update(revisions: revisions)
        expect(card.review_date).to eq Date.today + dys
      end
    end
  end

  describe '#increase_count' do
    let(:user) { create :user }
    let(:deck) { create(:deck, user: user) }
    let(:card) { create(:card, deck: deck, user: user) }
    it 'will increase a revisions number by 1' do
      card.update(attempts: 3, revisions: 0)
      card.increase_count
      expect(card.revisions).to eq 1
      card.update(attempts: 3, revisions: 6)
      card.increase_count
      expect(card.revisions).to eq 0
      card.update(attempts: 1, revisions: 0)
      card.increase_count
      expect(card.attempts).to eq 3
    end
  end

  describe '#decrease_count' do
    let(:user) { create :user }
    let(:deck) { create(:deck, user: user) }
    let(:card) { create(:card, deck: deck, user: user) }
    it 'will decrease an attempts number by 1' do
      card.update(attempts: 3, revisions: 0)
      card.decrease_count
      expect(card.attempts).to eq 2
      card.update(attempts: 1, revisions: 1)
      card.decrease_count
      expect(card.revisions).to eq 0
      card.update(attempts: 1, revisions: 1)
      card.decrease_count
      expect(card.attempts).to eq 3
    end
  end
end
