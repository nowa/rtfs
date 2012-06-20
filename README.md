RTFS
====

RTFS is a Ruby Client for TFS.  

[About TFS](http://code.taobao.org/project/view/366/)

Requirements
------------

* Linux System (TFS only success build in Linux system.)
* TFS 

Configure
---------

create this files before using.

config/tfs.yml

    defaults: &defaults
      host: '127.0.0.1:3100'
      appkey: "......."

    development:
      <<: *defaults

    test:
      <<: *defaults

    production:
      <<: *defaults
      
config/initialize/tfs.rb

    require 'rtfs'
    tfs_config = YAML.load_file("#{Rails.root}/config/tfs.yml")[Rails.env]
    $tfs = RTFS::Client.tfs(tfs_config.merge({:ns_addr => tfs_config['host']}))

:ns_addr include http:// tfs used webservice

Configure without TFS install
-----------------------------

If you development environment is Mac, or your developemnt environment not install TFS, you need use this file to hack upload file as FileSystem. 

lib/fake_tfs.rb

    module FakeTfs
      class Client
        def initialize(options = {})
          @ns_addr = options[:ns_addr] || "uploads/tfs/"
          if @ns_addr[0] != "/"
            @ns_addr = [Rails.root,"public",@ns_addr].join("/")
          end
        end
    
        def put_file(file_path, options = {})
          ext = options[:ext] || File.extname(file_path)
          ext = ".jpg" if ext.blank?
          file_name = [Digest::SHA1.hexdigest(file_path),ext].join("")

          new_path = [@ns_addr,file_name].join("/")

          FileUtils.cp(file_path, new_path)
          File.basename(new_path)
        end
    
        def rm_file(file_id)
          puts "FakeTFS: removing #{file_id}\n"
          Dir.glob(File.join(@ns_addr, "#{file_id}.*"))[0]
        end
      end
    end


config/tfs.yml

    defaults: &defaults
      host: 'uploads/tfs/'

    development:
      <<: *defaults

    test:
      <<: *defaults

    production:
      <<: *defaults
      host: '127.0.0.1:3100'

config/initialize/tfs.rb

    tfs_config = YAML.load_file("#{Rails.root}/config/tfs.yml")[Rails.env]
    if Rails.env == "development"
      $tfs = FakeTfs::Client.new(:ns_addr => tfs_config['host'])
    else
      require 'rtfs'
      $tfs = RTFS::Client.tfs(tfs_config.merge({:ns_addr => tfs_config['host']}))
    end


Usage
-----

    class UsersController < ApplicationController
      def save
        @user = User.new
        ext = File.extname(params[:Filedata].original_filename)
        file_name = $tfs.put(params[:Filedata].tempfile.path, :ext => ext)
        @user.avatar_path = [file_name,ext].join("")
      end
    end
    
    
    class User < ActiveRecord::Base
      def avatar_url
        server_id = self.id % 4 + 1
        "http://img#{server_id}.tbcdn.com/#{self.avatar_path}"
      end
    end
    
Put local file to TFS

    $ $tfs.put("~/Downloads/a.jpg")
    T1Ub1XXeFBXXb1upjX