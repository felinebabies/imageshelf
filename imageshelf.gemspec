# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'imageshelf/version'

Gem::Specification.new do |spec|
  spec.name          = "imageshelf"
  spec.version       = Imageshelf::VERSION
  spec.authors       = ["Syuji"]
  spec.email         = ["commentonly.is@gmail.com"]

  spec.summary       = %q{Image shelf ローカル画像管理ライブラリ}
  spec.description   = %q{ローカルストレージに保存した画像にタグを付与したり、同一画像の重複チェックを
  行うライブラリです。コマンドラインで情報の更新ができる他、webインターフェースでの管理編集機能も提供
  しています。
}.split("\n").join
  spec.homepage      = "https://github.com/felinebabies/imageshelf"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  #if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  #else
  #  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  #end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_dependency "thor"
  spec.add_dependency "sqlite3"
  spec.add_dependency "sinatra"
  spec.add_dependency "haml"
  spec.add_dependency "rmagick"
  spec.add_dependency "kaminari"
  spec.add_dependency "kaminari-sinatra"
  spec.add_dependency "padrino-helpers"
end
