# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ddcloud/version"

Gem::Specification.new do |s|
  s.name        = "didata_cloud_sdk"
  s.version     = DDcloud::VERSION
  s.authors     = ["Juozas Gaigalas", "Tim Wade", "Stijn Muylle"]
  s.email       = ["juozasgaigalas@gmail.com", "pimpingeezer@gmail.com", "stijnmuylle@gmail.com"]
  s.licenses 	= ['MIT']
  s.homepage    = ""
  s.summary     = %q{Dimension Data REST API client gem}
  s.description = %q{SDK to access Dimension Data Cloud api'}

  s.rubyforge_project = "ddcloud"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'i18n'
  s.add_dependency 'activesupport'
  s.add_dependency 'typhoeus'
  s.add_dependency 'xml-simple'
  s.add_dependency 'hashie'
  s.add_dependency 'colorize'
end
