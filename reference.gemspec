Gem::Specification.new do |spec|
  spec.name          = 'reference.rb'
  spec.version       = '0.1.0'
  spec.date          = '2015-09-13'
  spec.summary       = "A value holder. Like pointers in other languages, or a mutable Optional."
  spec.description   = "A value holder. Like pointers in other languages, or a mutable Optional."
  spec.authors       = ["Keith Kim"]
  spec.email         = ['keith.karmakaze@gmail.com']
  spec.files         = `git ls-files`.split($\)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.homepage      = 'http://github.com/karmakaze/reference.rb'
  spec.license       = 'MIT'

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "awesome_print"
end
