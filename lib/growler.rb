class Growler
  require 'faraday'
  require 'json'
  require 'hashie'

  def connect
    Faraday.new :url => "http://api.hungrlr.dev"
  end

  def get_user_growls(display_name, token)
    user_growls = connect.get "v1/feeds/#{display_name}.json?token=#{token}"
    user_growls = user_growls.body
    parsed_growls = JSON.parse(user_growls)
    
    full_response = Hashie::Mash.new parsed_growls
    growls = full_response.items.most_recent
  end

end