require 'spec_helper'

describe Growler do
  let(:user) { "wengzilla" }
  let(:token) { "HUNGRLR" }
  let(:client) { Growler.new(token)}


  describe "verify authentication" do
    it "401 with invalid token" do
      invalid_client = Growler.new("sdfsd")
      invalid_client.status.should == 401
    end

    it "200 with VALID token" do
      client.status.should == 200
    end
  end
  describe ".get_user_growls" do
    it "can get user growls" do
      client.get_user_growls(user)[:status].should == 200
      client.get_user_growls(user)[:response].first.class.should == Hashie::Mash
    end
    describe "Posting" do
      it ".post_message" do
        message = client.post_message("wengzilla", "Testing client gem")
        message[:status].should == 201
        client.destroy_post("wengzilla", message[:response]["id"])[:status].should == 201
      end
      it ".post_link" do
        link = client.post_link("wengzilla", "http://google.com")
        link[:status].should == 201
        client.destroy_post("wengzilla", link[:response]["id"])[:status].should == 201
      end
      it ".post_image" do
        image = client.post_image("wengzilla", "http://www.enn.com/image_for_articles/33228-1.jpg")
        image[:status].should == 201
        client.destroy_post("wengzilla", image[:response]["id"])[:status].should == 201
      end
    end
    describe "Regrowl" do
      it "Can regrowl" do
        client.regrowl("mikesilvis", 7)[:status].should == 201
      end
      describe "Self destruct" do
        it "Can Destroy regrowl" do
          client.destroy_regrowl("mikesilvis", 7)[:status].should == 201
        end
      end
    end
  end
end