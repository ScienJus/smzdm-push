class SubscribeMailer < ApplicationMailer
  default from: '931996776@qq.com'

  def push_email(email, keywords, articles)
    @email = email
    @keyword = keywords.join(',')
    @articles = articles
    mail(to: @email, subject: "您订阅的[#{@keyword}]有了#{@articles.length}条新推送！")
  end
end
