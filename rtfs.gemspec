# coding: utf-8
Gem::Specification.new do |s|
  s.name             = "rtfs"
  s.version          = "0.1.1"
  s.platform         = Gem::Platform::RUBY
  s.has_rdoc         = true
  s.extra_rdoc_files = ["README.md","CHANGES.md","MIT-LICENSE",]
  s.summary          = "RTFS is a Ruby Client for TFS."
  s.author           = ["Nowa Zhu","Jason Lee","Cricy"]
  s.email            = ["nowazhu@gmail.com","huacnlee@gmail.com","feiyelanghai@gmail.com"]
  s.homepage         = "https://github.com/nowa/rtfs"
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths    = ["lib"]
  s.bindir           = 'bin'

  s.add_dependency("nice-ffi", ">=0.4")
  s.add_dependency("rest-client", ">=1.6.0")
end
