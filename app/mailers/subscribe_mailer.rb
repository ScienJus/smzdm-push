class SubscribeMailer < ApplicationMailer
  default from: 'test@qq.com'

  def push_email(email, keywords, article)
    @email = email
    @keyword = keywords.join(',')
    @article = article
    mail(to: @email, subject: "您订阅的[#{@keyword}]有了一条新推送！")
  end
end
