class Almailer < ActionMailer::Base
  default from: "Progmr@Progmr.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.almailer.new_comment_notification.subject
  #
  def new_comment_notification(comment)
    @post = comment.post
    @comment = comment
    @op = comment.post.user
    mail to: @op.email, subject: (t :newCommentNotificationEmailSubject)
  end
end
