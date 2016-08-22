class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@on-flashcards.herokuapp.com'
  layout 'mailer'
end
