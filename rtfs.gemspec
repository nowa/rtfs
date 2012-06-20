# Generated: Sun Oct 09 04:07:05 UTC 2011
Gem::Specification.new do |s|
  s.name = "rtfs"
  s.version = "0.1.0"
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.md","CHANGES.md","MIT-LICENSE",]
  s.summary = "RTFS is a Ruby Client for TFS."
  s.author = "Nowa Zhu"
  s.email = "nowazhu@gmail.com"
  s.homepage = "https://github.com/nowa/rtfs"
  s.add_dependency("nice-ffi", ">=0.4")
  s.add_dependency("rest-client", ">=1.6.0")
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
  s.bindir = 'bin'
end
