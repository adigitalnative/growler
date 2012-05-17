require 'spec_helper'

describe Growler do
  let(:user) { "jq" }
  let(:token) { "tsukahara" }

  it "provides an array of hashie mashes" do
    client = Growler.new
    growls = client.get_user_growls(user, token)
    growls.each do |growl|
      growl.class.should == Hashie::Mash
    end
  end

  it "gives all the current user's growls" do
    pending "TODO: Research accessing DB from gem"
  end

  it "doesn't provide other growls" do
    pending "TODO: Research accessing DB from gem"
  end


end