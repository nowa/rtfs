# encoding utf-8
require 'rest-client'
require "json"

module RTFS
  class WebService

    attr_accessor :appkey
    attr_accessor :ns_addr

    def initialize(options)
      return nil unless options
      @ns_addr = options[:ns_addr]
      @appkey = options[:appkey]
    end
      
    # 获取文件
    def get(tfs_name, local_file=nil)
      RestClient.get(get_url("/v1/#{appkey}/#{tfs_name}"))
    end
    
    # 上传文件
    # 参数:
    #   file_path     需要上传的文件路径
    #   :ext          扩展名，默认会取 file_path 的扩展名, 如: .jpg
    # 返回值
    #   T1lpVcXftHXXaCwpjX
    def put(file_path, options = {})
        ext = options[:ext] || File.extname(file_path)
        response = RestClient.post(get_url("/v1/#{appkey}",{:suffix => ext, :simple_name => options[:simple_name] || 0}),File.open(file_path).read, :accept => :json )
        json = JSON.parse(response)
        json && json["TFS_FILE_NAME"] ? json["TFS_FILE_NAME"] : nil

    end
    
    # 上传文件 并返回完整 url (only for Taobao)
    def put_and_get_url(file_path, options = {})
        ext = options[:ext] || File.extname(file_path)
        t = put(file_path, :ext => ext)
        t.nil? ? nil : "http://img0#{rand(4)+1}.taobaocdn.com/tfscom/#{t}#{ext}"
    end
    
    # 删除文件, 不能带扩展名
    def rm(tfs_name,options = {})
        response = RestClient.delete(get_url("/v1/#{appkey}/#{tfs_name}", options))
        response && response.code == 200 ? true : nil
    end
    
    # 改名, 不能带扩展名
    def rename(tfs_name, new_name)
      #`#{tfstool_cmd} -i "rename #{tfs_name} #{new_name}"`
    end
    
    # 文件信息查看, 不能带扩展名
    def stat(tfs_name,options = {})
        response = RestClient.get(get_url("/v1/#{appkey}/metadata/#{tfs_name}", options))
        response && response.code == 200 ? JSON.parse(response) : nil
    end

    def client_name
      "WebService"
    end

    private


      def appkey
          @appkey
      end

      def get_url(url,opts = {})
          return url unless opts
          url = "#{@ns_addr}#{url}"
          params = []
          opts.each{|k,v|
              params << "#{k}=#{v}"
          }
          url.include?("?") ? "#{url}&#{params.join("&")}" : "#{url}?#{params.join("&")}"
      end

  end
end
