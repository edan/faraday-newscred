# -*- encoding: utf-8 -*-
Gem::Specification.new do |spec|
  spec.add_dependency 'faraday', '~> 0.8'

  spec.name          = 'faraday-newscred'
  spec.license       = 'MIT'
  spec.description   = 'Middleware to handle Newscred API'
  spec.summary       = 'A Faraday middleware for the Newscred API.'
  spec.authors       = ['edan']
  spec.email         = ['edan@edan.org']
  spec.homepage      = 'https://github.com/edan/faraday-newscred'

  spec.files         = Dir['LICENSE', 'README.md', 'lib/**/*']
  spec.test_files    = Dir['test/**/*']
  spec.require_paths = ['lib']
  spec.version       = '0.1.0'
end
