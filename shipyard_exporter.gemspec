require_relative 'lib/shipyard_exporter/version'

Gem::Specification.new do |spec|
  spec.name          = 'shipyard_exporter'
  spec.version       = ShipyardExporter::VERSION
  spec.authors       = ['Gan Yi Zhong']
  spec.email         = ['ganyizhong@gmail.com']

  spec.summary       = 'all-in-one exporter feature for Rails'
  spec.description   = 'add CSV export features to rails model'
  spec.homepage      = 'https://github.com/yzgan/shipyard_exporter'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4')

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/yzgan/shipyard_exporter.git'
  spec.metadata['changelog_uri'] = 'https://github.com/yzgan/shipyard_exporter/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'caxlsx'
  spec.add_dependency 'caxlsx_rails'
  spec.add_dependency 'draper', '~>4.0'
end
