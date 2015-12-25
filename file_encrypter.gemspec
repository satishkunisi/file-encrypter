# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'file_encrypter/version'

Gem::Specification.new do |spec|
  spec.name          = "file_encrypter"
  spec.version       = FileEncrypter::VERSION
  spec.authors       = ["Satish Kunisi"]
  spec.email         = ["kunisi@gmail.com"]
  spec.summary       = %q{A streaming symmetric file encrypter built on RbNaCl.}
  spec.description   = "WIP Do not use in production." 
  spec.homepage      = "http://github.com/satishkunisi/file-encrypter"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "http://gemserver.satishkunisi.com"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "rbnacl", "~> 3.2.0"
end
