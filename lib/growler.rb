class Growler
  attr_accessor :token, :status, :message
  require 'faraday'
  require 'json'
  require 'hashie'

  def connect
    Faraday.new :url => "http://api.hungrlr.dev/v1/"
  end

  def initialize(token)
    @token = token
    @status = validate_token[0]
    @message = validate_token[1]
  end

  def validate_token
    validation = connect.get do |req|
                    req.url "validate_token.json"
                    req.headers['AUTH_TOKEN'] = @token
                  end
    [validation.status, validation.body]
  end

  def get_user_growls(user)
    resp = connect.get do |req|
      req.url "feeds/#{user}.json"
      req.headers['AUTH_TOKEN'] = @token
    end
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
    resp = connect.post do |req|
      req.url "feeds/#{user}/growls", { body: content.to_json }
      req.headers['AUTH_TOKEN'] = token
    end
    response_object = Hashie::Mash.new(JSON.parse(resp.body))
    { status: resp.status, response: response_object }
  end

  def destroy_post(user, id)
    resp = connect.delete do |req|
      req.url "feeds/#{user}/growls", { id: id }
      req.headers['AUTH_TOKEN'] = token
    end
    { status: resp.status }
  end

  def regrowl(user, growl_id)
    resp = connect.post do |req|
      req.url "feeds/#{user}/growls/#{growl_id}/refeed"
      req.headers['AUTH_TOKEN'] = @token
    end
    { status: resp.status }
  end

  def destroy_regrowl(user, growl_id)
    resp = connect.delete do |req|
      req.url "feeds/#{user}/growls/#{growl_id}/refeed"
      req.headers['AUTH_TOKEN'] = @token
    end
    { status: resp.status }
  end

end

# client = Growler.new