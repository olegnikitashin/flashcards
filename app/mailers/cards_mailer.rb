class CardsMailer < ApplicationMailer
  def pending_card_notifications(email)
    @email = email
    mail to: @email,
         subject: 'You have unrevised cards!'
  end
end
