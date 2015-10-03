class SubscribeMailer < ApplicationMailer
  default from: '931996776@qq.com'

  def push_email(user, keyword, article)
    @user = user
    @keyword = keyword
    @article = article
    mail(to: @user.email, subject: "您订阅的[#{@keyword}]有了一条新推送！")
  end
end
