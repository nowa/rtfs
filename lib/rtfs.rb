# coding: utf-8
# TFS Client for Ruby
# by nowa<nowazhu@gmail.com> 2011-07-23
$:.unshift(File.dirname(__FILE__))

module RTFS; end

def require_local(suffix)
  require(File.expand_path(File.join(File.dirname(__FILE__), suffix)))
end

require 'rubygems'
require 'nice-ffi'
require 'yaml'

# require_local 'rtfs/wrapper.rb'
require 'rtfs/client.rb'
require 'rtfs/web_service.rb'
require 'rtfs/tfstool.rb'
require 'rtfs/meta.rb'
require 'rtfs/version.rb'

# tfs = RTFS::Client.new({:ns_addr => '10.246.65.210:3100'})
# puts "tfsname: '#{tfs.put_file_and_get_url("/home/xifeng/1.png")}'"
# puts "#{tfs.get_file('T1H9t5XeRwXXaCwpjX')}"
# puts "#{tfs.file_stat('T1H9t5XeRwXXaCwpjX').inspect}"
