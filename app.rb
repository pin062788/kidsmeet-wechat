require 'sinatra'
require 'wei-backend'
require 'httparty'
require 'json'

require_relative  'env.rb'

on_text do
  text = params[:Content]
  result = []
  if %w(1 2).include? text
    # parsed_json = (HTTParty.get("http://www.kidsmeet.cn?name=#{params[:FromUserName]}&eventType=all")).parsed_response
    file = File.read('events.json')
    parsed_json = JSON.parse(file) #mocked results
    parsed_json.map do |item|
      result << {
          :title => item['title'],
          :description => item['abstract'],
          :picture_url => item['main_image_url'],
          :url => URI.encode("#{SETTINGS[:app_url]}/events/1")
      }
    end
  else
    result = '查阅活动内容请发送“1”最新热门活动,“2”经典回顾'
  end
  result
end

on_subscribe do
  "感谢#{params[:FromUserName]}的订阅!查阅活动内容请发送“1”最新热门活动,“2”经典回顾"
end

on_unsubscribe do
    "欢迎您再次订阅!"
end

token 'server_access_token'