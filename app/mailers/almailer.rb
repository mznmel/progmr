class Almailer < ActionMailer::Base
  default from: "Progmr@Progmr.com"

  def new_comment_op_notification(comment)
    @post = comment.post
    @comment = comment
    @op = comment.post.user
    mail to: @op.email, subject: (t :newCommentNotificationEmailSubject)
  end

  def new_reply_parent_notification(comment)
    @post = comment.post
    @comment = comment
    @parentCommentUser = comment.parent.user
    mail to: @parentCommentUser.email, subject: (t :newReplyNotificationEmailSubject)
  end

  def featured_notification(post)
    @post = post
    mail to: @post.user.email, subject: (t :featuredNotificationEmailSubject)
  end
end
