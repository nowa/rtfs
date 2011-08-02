# Code for client
# by nowa<nowazhu@gmail.com> 2011-07-23

module RTFS
	TFSTOOL_PATH = "/home/admin/tfs/bin/tfstool"

	class Client
		attr_accessor :ns_addr
		attr_accessor :tfstool_path
	
		def initialize(options)
			return nil unless options
			@ns_addr = options[:ns_addr]
			@tfstool_path = options[:tfstool_path] ? options[:tfstool_path] : TFSTOOL_PATH
			raise NoTFSToolError.new unless File.exist?(@tfstool_path)
		end
		
		# ��tfs��ȡ�ļ�
		def get_file(tfs_name, local_file=nil)
			local_file ||= tfs_name
			`#{tfstool_cmd} -i "get #{tfs_name} #{local_file}"`
		end
		
		# �����ļ���tfs�������ļ���tfsname
		# tfsname example: T1lpVcXftHXXaCwpjX
		def put_file(local_file, tfs_name="NULL", suffix=nil)
			suffix ||= ".#{local_file.split(".").last}"
			result = `#{tfstool_cmd} -i "put #{local_file} #{tfs_name} #{suffix}"`
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
		
		# �����ļ���tfs�������ļ��Ŀɷ���cdn url
		def put_file_and_get_url(local_file, tfs_name="NULL", suffix=nil)
			suffix ||= ".#{local_file.split(".").last}"
			t = put_file(local_file, tfs_name, suffix)
			t.nil? ? nil : "http://img03.taobaocdn.com/tfscom/#{t}#{suffix}"
		end
		
		# ɾ��tfs file
		def rm_file(tfs_name)
			`#{tfstool_cmd} -i "rm #{tfs_name}"`
		end
		
		# ������tfs file�����Ƽ�ʹ��
		# new name ����Ҳ�� tfsname ��ʽ
		def rename_file(tfs_name, new_name)
			`#{tfstool_cmd} -i "rename #{tfs_name} #{new_name}"`
		end
		
		# ��ȡtfs file��stat
		def file_stat(tfs_name)
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