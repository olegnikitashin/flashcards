class CardsMailerPreview < ActionMailer::Preview
  def pending_card_notifications
    CardsMailer.pending_card_notifications(User.first.email)
  end
end
