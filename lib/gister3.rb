require 'faraday'
require 'json'
# require 'hashie'
require 'ostruct'

class Gister3

  def connection
    Faraday.new :url => "https://api.github.com"
  end

  def get_all_gists
    response = connection.get "users/adigitalnative/gists"
    response.body
  end

  def parse_all_gists
    parsed_data = JSON.parse(get_all_gists)
    @structeds = {}
    parsed_data.collect do |gist| 
      structed = ostruct_it(gist)
      @structeds << structed
    end
  end

  def ostruct_it(gist)
    OpenStruct.new gist
  end

  # def mash_it(gist)
  #   mash = Hashie::Mash.new gist
  # end 
end