require 'spec_helper'
require 'open-uri'

describe 'custom operations' do
  it 'should save named file' do
    path = $tfs.save('spec/a.jpg', :path => 'bar.jpg')

    f = open("http://img01.daily.taobaocdn.net/L1/#{path}")
    f.read.length.should eq(6511)

    $tfs.del('spec/a.jpg', :path => 'bar.jpg').should eq(true)
  end

  it 'should expose appid' do
    $tfs.appid.should eq('133')
  end

  it 'should respect global uid settings' do
    # 自动生成的 uid 是经过 % 10000 的，也就是说，不会超过 10000，
    # 所以，自定义 uid 只要大于等于 10000，就尽管用吧
    $tfs.uid = 10000
    path = $tfs.save('spec/a.jpg', :path => 'ham.jpg')

    path.should =~ /10000/

    $tfs.del('spec/a.jpg', :path => 'ham.jpg').should eq(true)
  end
end