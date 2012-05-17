require 'spec_helper'

describe Growler do

  it "provides an array of ostructs" do
    client = Growler.new
    growls = client.get_user_growls("jq")
    growls.each do |growl|
      growl.class.should == OpenStruct
    end
  end

end