class Growler
  require 'faraday'
  require 'json'
  require 'hashie'

  def connect
    Faraday.new :url => "http://api.hungrlr.dev"
  end

  def get_user_growls(user, token)
    user_growls = connect.get "v1/feeds/#{user}.json",
      { :token => "#{token}" }
    user_growls = user_growls.body
    parsed_growls = JSON.parse(user_growls)
    
    full_response = Hashie::Mash.new parsed_growls
    growls = full_response.items.most_recent
  end

  # Not currently functional b/c api doesn't have functionality
  def post_growl(user, token, type, comment)
    # @growl_body = "{ 'type':#{type},'comment':#{comment} }"
    # @growl_body.to_json
    
    connect.post 'v1/feeds/jq/items', { token: "tsukahara", body: {type: "Message", comment: "Foo" }.to_json }
    # connect.post do |request|
    #   request.url "v1/feeds/#{user}/items",
    #     { :token => "#{token}"}
    #   # request.headers['AUTH-TOKEN'] = token
    #   request.body @growl_body
    # end

    # puts "Foo"
  end

end