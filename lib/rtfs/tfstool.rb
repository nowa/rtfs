module RTFS

  TFSTOOL_PATH = "/home/admin/tfs/bin/tfstool"
  class Tfstool

    attr_accessor :ns_addr
    attr_accessor :tfstool_path
  
    # 参数:
    #   :ns_addr          TFS 服务器地址，如 127.0.0.1:3100
    #   :tfstool_path     tfstool 安装路径，默认 /home/admin/tfs/bin/tfstool
    def initialize(options)
      return nil unless options
      @ns_addr = options[:ns_addr]
      @tfstool_path = options[:tfstool_path] ? options[:tfstool_path] : TFSTOOL_PATH
      if not File.exist?(@tfstool_path)
        puts "[RTFS] debuger: #{@tfstool_path}"
        raise NoTFSToolError.new
      end
    end
    
    # 获取文件
    def get(tfs_name, local_file=nil)
      local_file ||= tfs_name
      `#{tfstool_cmd} -i "get #{tfs_name} #{local_file}"`
    end
    
    # 上传文件
    # 参数:
    #   file_path     需要上传的文件路径
    #   :ext          扩展名，默认会取 file_path 的扩展名, 如: .jpg
    # 返回值
    #   T1lpVcXftHXXaCwpjX
    def put(file_path, options = {})
      ext = options[:ext] || File.extname(file_path)
      tfs_name = "NULL"
      result = `#{tfstool_cmd} -i "put #{file_path} #{tfs_name} #{ext}"`
      # puts "result: #{result}"
      t = nil 
      if result.include?("=> ")
        result = result.split("=> ").last
        if result.include?(",")
          t = result.split(",").first
        end
      end
      t.nil? ? nil : t
    end
    
    # 上传文件 并返回完整 url (only for Taobao)
    def put_and_get_url(file_path, options = {})
      ext = options[:ext] || File.extname(file_path)
      t = put(file_path, :ext => ext)
      t.nil? ? nil : "http://img03.taobaocdn.com/tfscom/#{t}#{ext}"
    end
    
    # 删除文件, 不能带扩展名
    def rm(tfs_name)
      `#{tfstool_cmd} -i "rm #{tfs_name}"`
    end
    
    # 改名, 不能带扩展名
    def rename(tfs_name, new_name)
      `#{tfstool_cmd} -i "rename #{tfs_name} #{new_name}"`
    end
    
    # 文件信息查看, 不能带扩展名
    def stat(tfs_name)
      result = `#{tfstool_cmd} -i "stat #{tfs_name}"`
      stat = {}
      result.split("\n").each do |line|
        line = line.split(':').map {|i| i.gsub!(" ", "")}
        stat["#{line.first}"] = line.last
      end
      stat
    end
    
    protected
      def tfstool_cmd
        "#{@tfstool_path} -n -s #{@ns_addr}"
      end
  end
  
  class NoTFSToolError < RuntimeError
    def to_s
      "You must install tfs from yum or source first!"
    end
  end # NoTFSToolError
end