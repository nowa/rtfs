# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "rtfs"

Gem::Specification.new do |s|
  s.name             = 'rtfs'
  s.version          = RTFS::Version.to_version
  s.platform         = Gem::Platform::RUBY

  s.has_rdoc         = true
  s.extra_rdoc_files = ['README.md', 'CHANGES.md', 'MIT-LICENSE']

  s.summary          = 'RTFS is a Ruby Client for TFS.'

  s.author           = ['Nowa Zhu', 'Jason Lee', 'Cricy', 'Jake Chen']
  s.email            = ['nowazhu@gmail.com', 'huacnlee@gmail.com']
  s.email           += ['feiyelanghai@gmail.com', 'jakeplus@gmail.com']

  s.homepage         = 'https://github.com/nowa/rtfs'
  s.license          = 'MIT'

  s.files            = Dir.glob('lib/**/*.rb')
  s.test_files       = Dir.glob('spec/**/*.rb')

  s.require_paths    = ['lib']
  s.bindir           = 'bin'

  s.add_dependency('rest-client', '>=1.6.0')
  s.add_development_dependency('json')
  s.add_development_dependency('rest-client', '>=1.6.0')
  s.add_development_dependency('rspec', '~> 2.5')
end
