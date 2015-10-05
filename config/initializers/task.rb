require 'rufus/scheduler'
require 'net/http'
require 'uri'
require 'json'

scheduler = Rufus::Scheduler.new

#记录上次采集开始时间
@last_collect_start_time = Time.now.to_i

scheduler.every '300s' do
  
  #记录这次采集开始时间
  this_collect_start_time = Time.now.to_i
  
  #因为一次采集可能会请求多次，记录每次请求的时间
  loop_request_time_sort = this_collect_start_time
  
  #记录推送信息
  push_users = {}
  
  #循环请求
  while loop_request_time_sort > @last_collect_start_time do
    
    #发现地址
    uri = URI('http://faxian.smzdm.com/json_more')

    #参数带上时间戳
    uri.query = URI.encode_www_form(
      timesort: loop_request_time_sort
    )  
    
    Net::HTTP.start(uri.host, uri.port) do |http|
      req = Net::HTTP::Get.new(uri)
    
      #必须设置user-agent，否则会403错误
      req.initialize_http_header(
        'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/600.4.10 (KHTML, like Gecko) Version/8.0.4 Safari/600.4.10'
      )
  
      #发送请求
      res = http.request req
  
      #解析返回json
      articles = JSON.parse res.body
      
      #遍历json
      articles.each do |article|
        #更新时间戳
        loop_request_time_sort = article['timesort']
        
        #如果时间戳已经在上次采集时间之前，说明此次采集已经完成
        break if loop_request_time_sort < @last_collect_start_time
        
        #处理采集到的数据
        content = article['article_title'] + article['article_content']
        
        #得到所有keyword
        keywords = Keyword.all
                
        keywords.each do |keyword|
          if content.downcase.include? keyword.name.downcase
            puts "keyword: #{keyword.name} content: #{content}"
            
            keyword.users.where(active: true).each do |user| 
              if push_users.has_key? user.email
                push_users[user.email][:keywords].push keyword.name unless push_users[user.email][:keywords].include? keyword.name
                push_users[user.email][:articles].push article unless push_users[user.email][:articles].include? article
              else
                push_users[user.email] = {}
                push_users[user.email][:keywords] = [keyword.name]
                push_users[user.email][:articles] = [article]
              end
            end
          end
        end        
      end
    end
  end
  
  #发布推送信息
  push_users.each do |email, value|
    SubscribeMailer.push_email(email, value[:keywords], value[:articles]).deliver
  end
  
  #更新上次采集时间
  @last_collect_start_time = this_collect_start_time
end
