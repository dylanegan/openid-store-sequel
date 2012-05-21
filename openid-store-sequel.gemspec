# -*- encoding: utf-8 -*-
require File.expand_path('../lib/openid/store/sequel/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dylan Egan"]
  gem.email         = ["dylanegan@gmail.com"]
  gem.description   = %q{Storing your OpenIDs in your Sequels.}
  gem.summary       = %q{Storing OpenIDs in Sequels.}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "openid-store-sequel"
  gem.require_paths = ["lib"]
  gem.version       = OpenID::Store::Sequel::VERSION

  gem.add_runtime_dependency "ruby-openid"
  gem.add_runtime_dependency "sequel"

  gem.add_development_dependency "pg"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "sqlite3"
end
