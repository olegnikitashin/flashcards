# Preview all emails at http://localhost:3000/rails/mailers/cards_mailer
class CardsMailerPreview < ActionMailer::Preview
  def pending_card_notifications
    CardsMailer.pending_card_notifications(User.first)
  end
end
