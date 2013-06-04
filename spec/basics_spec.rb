require 'spec_helper'
require 'open-uri'

describe 'Basic operations' do
  it 'should put and remove file' do
    rcount = $tfs.access_count

    fname = $tfs.put('spec/a.jpg')
    $tfs.access_count.should eq(rcount + 1)

    f = open("http://img01.daily.taobaocdn.net/tfscom/#{fname}.jpg")
    f.read.length.should eq(6511)

    $tfs.access_count = $tfs.nameservers[0].to_i
    $tfs.rm(fname).should eq(true)
    $tfs.access_count.should eq(0)
  end

  it 'should stat file' do
    fname = $tfs.put('spec/a.jpg')
    stat = $tfs.stat(fname)

    stat.should.is_a? Hash
    stat['FILE_NAME'].should eq(fname)
    stat['SIZE'].should eq(6511)

    $tfs.rm(fname)
  end
end