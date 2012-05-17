class Gister
  require 'faraday'
  require 'json'
  require 'ostruct'

  def connect
    Faraday.new :url => "https://api.github.com"
  end

  def get_all_gists
    all_gists = connect.get "/gists"
    all_gists = all_gists.body
    parsed_data = JSON.parse(all_gists)
    results = []

    parsed_data.each do |gist|
      response = OpenStruct.new gist
      results << response
    end
    return results
  end

  def get_user_gists(user)
    user_gists = connect.get "/users/#{user}/gists"
    user_gists = user_gists.body
    parsed_data = JSON.parse(user_gists)
    results = []

    parsed_data.each do |gist|
      response = OpenStruct.new gist
      results << response
    end
    return results
  end

  def get_user_repos(user)
    user_repos = connect.get "/users/#{user}/repos"
    user_repos = user_repos.body
    parsed_data = JSON.parse(user_repos)
    results = []

    parsed_data.each do |repo|
      repo = OpenStruct.new repo
      results << repo
    end
  end

  def count_user_repos(user)
    get_user_repos(user).count
  end
end