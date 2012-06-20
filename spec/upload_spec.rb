require "spec_helper"
require "open-uri"

describe "Base upload" do
  it "should upload" do
    fname = $tfs.put("spec/a.jpg")
    f = open("http://10.232.4.42/tfscom/#{fname}.jpg")
    f.read.length.should == 6153

    fname = $tfs.put("spec/b.jpg")
    f = open("http://10.232.4.42/tfscom/#{fname}.jpg")
    f.read.length.should == 114504
  end
end