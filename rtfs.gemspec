# Generated: Sun Oct 09 04:07:05 UTC 2011
Gem::Specification.new do |s|
  s.name = "rtfs"
  s.version = "0.0.4"
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.markdown","CHANGES","MIT-LICENSE",]
  s.summary = "RTFS is a Ruby Client for TFS."
  s.author = "Nowa Zhu"
  s.email = "nowazhu@gmail.com"
  s.homepage = "http://rtfs.labs.nowa.me"
  s.rubyforge_project = "rtfs"
  s.add_dependency("nice-ffi", ">=0.4")
#  s.require_path = "lib"
  s.files = ["lib/rtfs/meta.rb","lib/rtfs/version.rb","lib/rtfs/client.rb","lib/rtfs/wrapper.rb","lib/rtfs.rb",]
  s.bindir = 'bin'
  s.executables = ['top4rsh']
end
