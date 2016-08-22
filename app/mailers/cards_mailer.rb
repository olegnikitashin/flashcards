class CardsMailer < ApplicationMailer
  def pending_card_notifications(user)
    @email = user.email
    mail to: @email,
         subject: 'You have unrevised cards!'
  end
end
