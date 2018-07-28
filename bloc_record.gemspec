Gem::Specification.new do |s|
  s.name          = 'bloc_record'
  s.version       = '0.0.0'
  s.date          = '2018-07-08'
  s.summary       = 'BlocRecord ORM'
  s.description   = 'An ActiveRecord-esque ORM adaptor'
  s.authors       = ['Jocelyn Hsu']
  s.email         = 'hsu.joce@gmail.com'
  s.files         = Dir['lib/**/*.rb']
  s.require_paths = ["lib"]
  s.homepage      = 'http://rubygems.org/gems/bloc_record'
  s.license       = 'MIT'
  s.add_runtime_dependency 'sqlite3', '~> 1.3'
  s.add_runtime_dependency 'activesupport'
  s.add_runtime_dependency 'pg', '~>1.0.0'
end
