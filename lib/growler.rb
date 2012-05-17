class Growler
  require 'faraday'
  require 'json'
  require 'ostruct'

  def connect
    Faraday.new :url => "http://api.hungrlr.dev"
  end

  def get_user_growls(display_name, token)
    user_growls = connect.get "v1/feeds/#{display_name}.json?token=#{token}"
    user_growls = user_growls.body
    parsed_growls = JSON.parse(user_growls)
    
    full_response = OpenStruct.new parsed_growls
    response = OpenStruct.new full_response.items
    response = response.most_recent

    growls = []
    response.each do |growl|
      growl = OpenStruct.new growl
      growls << growl
    end
    return growls
  end

end