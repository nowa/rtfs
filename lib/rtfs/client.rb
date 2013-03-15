# coding: utf-8
# Code for client
# by nowa<nowazhu@gmail.com> 2011-07-23
require 'rest-client'
require 'open-uri'
require 'digest'
require 'json'

module RTFS

  class Client

    # 参数:
    #   :root          TFS WebService Root 服务器地址，如 127.0.0.1:3100
    def self.tfs(options)
      self.new(options) if options
    end

    attr_accessor :nameservers
    attr_accessor :appkey
    attr_accessor :uid

    def initialize(options)
      # 通过 ns_addr 的地址获取负载均衡的地址
      @nameservers = open("#{options[:ns_addr]}/tfs.list").read.split("\n")
      @appkey = options[:appkey]

      @basedir = options[:basedir]
      @uid = options[:uid]

      if @uid.nil? && !@basedir.nil?
        (Digest::MD5.hexdigest(@basedir).to_i(16) % 10000)
      end
    end

    # 获取文件
    def get(tfs_name)
      http_get("/v1/#{appkey}/#{tfs_name}")
    end

    # 上传文件
    # 参数:
    #   file_path     需要上传的文件路径
    #   :ext          扩展名，默认会取 file_path 的扩展名, 如: .jpg
    # 返回值
    #   T1lpVcXftHXXaCwpjX
    def put(path, options = {})
      ext = options[:ext] || File.extname(path)
      path = path.to_s
      resp = http_post("/v1/#{appkey}",
                       File.open(path.start_with?('/') ? path : fpath(path)).read,
                       :params => {
                         :suffix => ext,
                         :simple_name => options[:simple_name] || 0
                       },
                       :accept => :json)

      json = JSON.parse(resp)
      json && json['TFS_FILE_NAME']
    end

    # 上传文件 并返回完整 url (only for Taobao)
    def put_and_get_url(path, options = {})
      ext = options[:ext] || File.extname(path)
      path = path.to_s
      tname = put(path, :ext => ext)

      "http://img0#{rand(4)+1}.taobaocdn.com/tfscom/#{t}#{ext}" unless tname.nil?
    end

    # 删除文件, 不能带扩展名
    def rm(tname, options = {})
      resp = http_delete("/v1/#{appkey}/#{tname}", :params => options)

      resp && resp.code == 200
    end

    # 文件信息查看, 不能带扩展名
    def stat(tname, options = {})
      resp = http_get("/v1/#{appkey}/metadata/#{tname}", :params => options)

      if resp && resp.code == 200
        JSON.parse(resp)
      end
    end

    def save(path, options = {})
      path = path.to_s

      if finger(path)
        del(path)
        save(path)
      elsif create(path)
        write(path)
      end
    end

    def create(path, options = {})
      resp = http_post(furl(path), nil,
                       :params => {:recursive => 1})

      resp && resp.code == 201
    end

    def write(path, options = {})
      data = File.open(fpath(path)).read
      return if data.length == 0
      resp = http_put(furl(path), data,
                      :params => {:offset => 0})

      if resp && resp.code == 200
        [appid, fuid(path), path].join('/')
      end
    end

    def del(path, options = {})
      resp = http_delete(furl(path))

      resp && resp.code == 200
    end

    def finger(path, options = {})
      begin
        resp = http_head(furl(path))

        resp && resp.code == 200
      rescue RestClient::ResourceNotFound
        # this rescue is intended.
        # the purpose is to return nil if the path fingered returned 404.
        # hence there's nothing more to do.
      end
    end

    def appid
      return @appid unless @appid.nil?

      resp = http_get("/v2/#{appkey}/appid")

      if resp && resp.code == 200
        @appid = JSON.parse(resp)['APP_ID']
      end
    end


    private

    def http_get(url, *args)
      RestClient.get("#{nameserver}#{url}", *args)
    end

    def http_post(url, *args)
      RestClient.post("#{nameserver}#{url}", *args)
    end

    def http_delete(url, *args)
      RestClient.delete("#{nameserver}#{url}", *args)
    end

    def http_put(url, *args)
      RestClient.put("#{nameserver}#{url}", *args)
    end

    def http_head(url, *args)
      RestClient.head("#{nameserver}#{url}", *args)
    end

    # 随机取一个 nameserver 用于访问，tfs.list 内容如下：
    #
    #     50
    #     10.246.65.133:3900
    #     10.246.65.132:3900
    #     10.246.65.131:3900
    #     10.246.65.130:3900
    #     10.246.73.70:3900
    #     10.246.73.71:3900
    #     10.246.73.72:3900
    #
    def nameserver
      # 现在第一行是 50，表示频次，访问 50 次就要更新
      @nameservers[rand(@nameservers.size - 1) + 1]
    end

    # TFS 中需要这个 User ID，用来分散数据请求，减轻单台机器压力，最方便 uid 获取方式是，
    # 对传入的文件路径做哈希，取后几位。但是如果要把 TFS 当普通 CDN 使用，
    # 能够使用确定的 URL 更新文件的话，User ID 必须固定，只能不定期批量更新。
    # 因此这里也允许使用实例化时传入的 uid 参数。
    def fuid(path = nil)
      if @uid.nil? && path.nil?
        1
      else
        @uid || Digest::MD5.hexdigest(path).to_i(16) % 10000
      end
    end

    def furl(path)
      "/v2/#{appkey}/#{appid}/#{fuid(path)}/file/#{path}"
    end

    def fpath(path)
      @basedir ? File.join(@basedir, path) : path
    end
  end
end
