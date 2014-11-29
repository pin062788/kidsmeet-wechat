require 'sinatra'
require 'wei-backend'
require 'httparty'
require 'json'

require_relative  'env.rb'

on_text do
    # parsed_json = (HTTParty.get("http://www.kidsmeet.cn?name=#{params[:FromUserName]}&eventType=all")).parsed_response
  file = File.read('events.json')
  parsed_json = JSON.parse(file) #mocked results
    result = []
    parsed_json.map do |item|
      result << {
          :title => item['title'],
          :description => item['abstract'],
          :picture_url => item['main_image_url'],
          :url => URI.encode("#{SETTINGS[:app_url]}/events/#{item['id']}")
      }
    end
  result
end

on_subscribe do
    "感谢您的订阅"
end

on_unsubscribe do
    "欢迎您再次订阅"
end

token 'server_access_token'