# Code for client
# by nowa<nowazhu@gmail.com> 2011-07-23
module RTFS

  class Client
  
    # 参数:
    #   :ns_addr          TFS 服务器地址，如 127.0.0.1:3100
    #   :tfstool_path     tfstool 安装路径，默认 /home/admin/tfs/bin/tfstool
    def self.tfs(options)
      return nil unless options
      if options[:ns_addr].include?("http://")
        return RTFS::WebService.new(options)
      else
        return RTFS::Tfstool.new(options)
      end
    end

  end
end
