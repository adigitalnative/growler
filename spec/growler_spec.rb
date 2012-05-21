require 'spec_helper'

describe Growler do
  let(:user) { "jq" }
  let(:token) { "tsukahara" }

  describe "get_user_growls" do

    it "gets feeds" do
      client = Growler.new
      client.should respond_to(:get_user_growls)
    end

    it "provides an array of hashie mashes" do
      client = Growler.new
      growls = client.get_user_growls(user, token)
      growls.each do |growl|
        growl.class.should == Hashie::Mash
      end
    end
  end

  describe "post_message" do
    pending "could test in app, not client?"
  end

  describe "post_image" do
    pending "could test in app, not client?"
  end

  describe "post_url" do
    pending "could test in app, not client?"
  end

  describe "regrowl" do
    pending "could test in app, not client?"
  end
end