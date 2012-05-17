require 'spec_helper'

describe Gister3 do

  it "fails" do
    Gister3.new
    Gister3.talk_to_me.should == "String"
  end

end