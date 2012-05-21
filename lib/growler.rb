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

  def post_message(user, token, comment)
    growl_body = { type: "Message", comment: comment }

    the_growl = connect.post "v1/feeds/#{user}/items", { token: token, body: growl_body.to_json }

    status = the_growl.status
    if status == 201
      puts "Congratulations, you have growled successfully. Here's a summary."
      puts "Status: #{status}"
      puts "User: #{user}"
      puts "Type: Message"
      puts "Comment: #{comment}"
    else
      puts "There was a problem. Please try your growl again."
      puts "Status: #{status}"
    end

    # Eventually may need to use this format to use auth-headers
    # connect.post do |request|
    #   request.url "v1/feeds/#{user}/items", { :token => "#{token}"}
    # #   # request.headers['AUTH-TOKEN'] = token
    #   request.body growl_body.to_json
    # end
  end

  # If passing no comment, must use 'nil' for comment
  def post_image(user, token, url, comment)
    growl_body = { type: "Image", link: url, comment: comment }

    the_growl = connect.post "v1/feeds/#{user}/items", { token: token, body: growl_body.to_json }

    status = the_growl.status
    if status == 201
      puts "Congratulations, you growled successfully. Here's a summary:"
      puts "Status: #{status}"
      puts "User: #{user}"
      puts "Type: Image"
      puts "Comment: #{comment}"
    else
      puts "There was a problem. Please try your growl again"
      puts "Status: #{status}"
    end
  end


  # If passing no comment, must use 'nil' for comment
  def post_url(user, token, url, comment)
    growl_body = { type: "Link", link: url, comment: comment }

    the_growl = connect.post "v1/feeds/#{user}/items", { token: token, body: growl_body.to_json }

    status = the_growl.status
    if status == 201
      puts "Congratulations, you growled successfully. Here's a summary:"
      puts "Status: #{status}"
      puts "User: #{user}"
      puts "Type: Link"
      puts "Comment: #{comment}"
    else
      puts "There was a problem. Please try your growl again"
      puts "Status: #{status}"
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
      puts "There was a problem. Please try your growl again"
      puts "Status: #{status}"
    end
  end
end