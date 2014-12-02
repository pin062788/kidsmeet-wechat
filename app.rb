require 'sinatra'
require 'wei-backend'
require 'httparty'
require 'json'

require_relative  'env.rb'

on_text do
  text = params[:Content]
  result = []
  if %w(1 2).include? text
    result = create_message(result, text)
  else
    result = "查阅活动内容请发送:\n   (1) 最新热门活动\n   (2) 经典回顾"
  end
  result
end

on_subscribe do
  "感谢您的订阅!\n查阅活动内容请发送:\n   (1) 最新热门活动\n   (2) 经典回顾"
end

on_unsubscribe do
  '欢迎您再次订阅!'
end

token 'server_access_token'

def retrieve_events(text)
  event_type = {'1' => 'upcomings', '2' => 'histories'}
  (HTTParty.get("http://kidsmeet.cn/agents/#{params[:ToUserName]}/#{event_type[text]}.json")).parsed_response['events']
end

def create_message(result, text)
  events = retrieve_events(text)
  if events.empty?
    result = "您搜查询的内容为空,重新查询请发送:\n   (1) 最新热门活动\n   (2) 经典回顾"
  else
    events.map do |item|
      result << {
          :title => item['title'],
          :description => item['abstract'],
          :picture_url => item['main_image_url'],
          :url => item['url']
      }

    end
  end
  result
end
