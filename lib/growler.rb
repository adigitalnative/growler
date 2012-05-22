class Growler
  attr_accessor :token, :status, :message
  require 'faraday'
  require 'json'
  require 'hashie'

  def connect
    Faraday.new :url => "http://api.hungrlr.com/v1/"
  end

  def initialize(token)
    @token = token
    @status = validate_token[0]
    @message = validate_token[1]
  end

  def validate_token
    validation = connect.get "validate_token.json", { token: @token }
    # validation = connect.get do |req|
    #                 req.url "validate_token.json"
    #                 req.headers['HTTP_X_AUTHTOKEN'] = @token
    #               end

    [validation.status, validation.body]
  end

  def get_user_growls(user)
    resp = connect.get "feeds/#{user}.json", { token: @token }
    response = JSON.parse(resp.body)["items"]["most_recent"].collect do |growl|
                 Hashie::Mash.new(growl)
               end
    {status: resp.status, response: response }
  end

  def post_message(user, comment)
    growl_body = { type: "Message", comment: comment }
    post(user,growl_body)
  end

  def post_image(user, url, comment=nil)
    growl_body = { type: "Image", link: url, comment: comment }
    post(user, growl_body)
  end


  def post_link(user, url, comment=nil)
    growl_body = { type: "Link", link: url, comment: comment }
    post(user, growl_body)
  end

  def post(user, content)
    resp = connect.post "feeds/#{user}/growls", { token: @token, body: content.to_json }
    response_object = Hashie::Mash.new(JSON.parse(resp.body))
    { status: resp.status, response: response_object }
  end

  def destroy_post(user, id)
    resp = connect.delete "feeds/#{user}/growls", { token: @token, id: id }
    { status: resp.status }
  end

  def regrowl(user, growl_id)
    resp = connect.post "feeds/#{user}/growls/#{growl_id}/refeed", { token: @token }
    { status: resp.status }
  end

  def destroy_regrowl(user, growl_id)
    resp = connect.delete "feeds/#{user}/growls/#{growl_id}/refeed", { token: @token }
    { status: resp.status }
  end

end

# client = Growler.new