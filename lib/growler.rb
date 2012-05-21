class Growler
  require 'faraday'
  require 'json'
  require 'hashie'

  def connect
    Faraday.new :url => "http://api.hungrlr.dev"
  end

  def initialize
    puts "Welcome to Growler!"
    puts "You have started with a Growler named 'client'."
    puts "Available commands are:"
    puts "  get_user_growls(user, token)"
    puts "  post_message(user, token, comment)"
    puts "  post_image(user, token, url, comment)"
    puts "  post_url(user, token, url, comment)"
    puts "  regrowl(user, user_token, growl_id)"
  end

  def get_user_growls(user, token)
    user_growls = connect.get "v1/feeds/#{user}.json",
      { :token => "#{token}" }
    if user_growls.status == 200
      parsed_growls = JSON.parse(user_growls.body)
      full_response = Hashie::Mash.new parsed_growls
      growls = full_response.items.most_recent
    else
      puts "There is a problem with your request. Please try again."
      puts "Error Message: #{user_growls.status}"
    end
  end

  def post_message(user, token, comment)
    growl_body = { type: "Message", comment: comment }
    the_growl = connect.post "v1/feeds/#{user}/items", { token: token, body: growl_body.to_json }

    status = the_growl.status
    if status == 201
      successful_post_message
      puts "Post: Message"
    else
      failed_post_message
    end

    # Eventually may need to use this format to use auth-headers
    # connect.post do |request|
    #   request.url "v1/feeds/#{user}/items", { :token => "#{token}"}
    # #   # request.headers['AUTH-TOKEN'] = token
    #   request.body growl_body.to_json
    # end
  end

  def post_image(user, token, url, comment)
    growl_body = { type: "Image", link: url, comment: comment }
    the_growl = connect.post "v1/feeds/#{user}/items", { token: token, body: growl_body.to_json }

    status = the_growl.status
    if status == 201
      successful_post_message
      puts "Type: Image"
    else
      failed_post_message
    end
  end


  def post_url(user, token, url, comment)
    growl_body = { type: "Link", link: url, comment: comment }
    the_growl = connect.post "v1/feeds/#{user}/items", { token: token, body: growl_body.to_json }

    status = the_growl.status
    if status == 201
      successful_post_message
      puts "Type: Link"
    else
      failed_post_message
    end
  end

  # User should be same as growl_id's user. Token identifies retweeter
  def regrowl(user, user_token, growl_id)
    regrowl = connect.post "v1/feeds/#{user}/growls/#{growl_id}/refeed", { token: "#{user_token}" }

    status = regrowl.status
    if status == 201
      puts "Congratulations, you regrowled successfully."
      puts "Status: #{status}"
    else
      failed_post_message
    end
  end

  def successful_post_message
    puts "Congratulations, you have growled successfully. Here's a summary."
    puts "Status: #{status}"
    puts "User: #{user}"
    puts "Content: #{growl_body}"
  end

  def failed_post_message
    puts "There was a problem. Please try your growl again"
    puts "Status: #{status}"
  end
end

client = Growler.new