class Growler
  require 'faraday'
  require 'json'
  require 'ostruct'

  def connect
    Faraday.new :url => "http://api.hungrlr.dev"
  end

  def get_user_growls(display_name)
    user_growls = connect.get "v1/feeds/#{display_name}.json"
    user_growls = user_growls.body
    parsed_data = JSON.parse(user_growls)

    full_response = OpenStruct.new parsed_data
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