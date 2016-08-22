require "rails_helper"

RSpec.describe CardsMailer, type: :mailer do
  describe 'User tests cards' do
    let!(:user) { create :user }
    let!(:deck) { create(:deck, user: user) }
    let!(:card) do
      card = create(:card, user: user, deck: deck, review_date: Date.today)
      card.update_attributes(review_date: Date.today.days_ago(3))
    end
    let!(:mail) { CardsMailer.pending_card_notifications(user)}

    it 'renders the subject' do
      expect(mail.subject).to have_content 'You have unrevised cards!'
    end

    it 'renders the user email' do
      expect(mail.to).to eq [user.email]
    end

    it 'renders the sender email' do
      expect(mail.from).to eq ['no-reply@on-flashcards.herokuapp.com']
    end

    it 'renders the letter' do
      expect(mail.html_part).to have_content 'You have unrevised cards! Please visit your '
    end
  end
end
