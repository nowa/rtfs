# ʹ��ffi��nice-ffi�����ö�̬���c�ӿ�
# tfsclient c apiĿǰ�в����ƣ�����c�ӿڵķ�װ���ò�����������
# ���Ŀǰ��ʹ�ø�wrapper���ļ��ݴ�
# by nowa<nowazhu@gmail.com> 2011-07-23

module LibC
  extend FFI::Library
  # figures out the correct libc for each platform including Windows
  library = ffi_lib(FFI::Library::LIBC).first

  # Size_t not working properly on Windows
  find_type(:size_t) rescue typedef(:ulong, :size_t)

  # memory allocators
  attach_function :malloc, [:size_t], :pointer
  attach_function :free, [:pointer], :void
  
  # get a pointer to the free function; used for ZMQ::Message deallocation
  Free = library.find_symbol('free')

  # memory movers
  attach_function :memcpy, [:pointer, :pointer, :size_t], :pointer
end # module LibC

module LibRTFS
	extend NiceFFI::Library

	libs_dir = "/home/admin/tfs/lib/"
	pathset = NiceFFI::PathSet::DEFAULT.prepend(libs_dir)
	
	load_library("tfsclient_c", pathset)

	attach_function :t_initialize, [:string, :int, :int], :int
	
	#enum OpenFlag
		#     {
		#       T_READ = 1,
		#       T_WRITE = 2,
		#       T_CREATE = 4,
		#       T_NEWBLK = 8,
		#       T_NOLEASE = 16,
		#       T_STAT = 32,
		#       T_LARGE = 64
		#     }; 		
	attach_function :t_open, [:string, :string, :string, :int, :string], :int
	attach_function :t_read, [:int, :pointer, :int], :int
	attach_function :t_write, [:int, :pointer, :int], :int
	attach_function :t_lseek, [:int, :int, :int], :int
	attach_function :t_pread, [:int, :pointer, :int, :int], :int
	attach_function :t_pwrite, [:int, :pointer, :int, :int], :int
	attach_function :t_fstat, [:int, :pointer, :int], :int
	attach_function :t_close, [:int, :string, :int], :int
	attach_function :t_unlink, [:string, :string, :int], :int
end 

# �����ⲿ�ִ����������LibRTFS
# LibRTFS.t_initialize("10.232.35.32:3100", 5, 1000)
# fd = LibRTFS.t_open("test", ".png", nil, 2, nil)
# puts "fd: #{fd}"
# 
# ori_file = nil
# File.open("/home/xifeng/1.png", "r") do |f|
# 	ori_file = f.read
# end
# buffer = LibC.malloc ori_file.size
# buffer.write_string ori_file, ori_file.size
# puts "write: #{LibRTFS.t_write(fd, buffer, ori_file.size)}"