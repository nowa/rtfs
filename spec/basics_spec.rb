require 'spec_helper'
require 'open-uri'

describe 'Basic operations' do
  it 'should put and remove file' do
    fname = $tfs.put('spec/a.jpg')

    f = open("http://img01.daily.taobaocdn.net/tfscom/#{fname}.jpg")
    f.read.length.should eq(6511)

    $tfs.rm(fname).should eq(true)
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