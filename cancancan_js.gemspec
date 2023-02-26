# gem build cancancan_js.gemspec

Gem::Specification.new do |s|
  s.name = %q{cancancan_js}
  s.version = "0.0.0"
  s.date = %q{2023-02-25}
  s.authors = ["benjamin.dana.software.dev@gmail.com"]
  s.summary = %q{CanCanCan, But Accessible in the Front-End Javascript}
  s.licenses = ['LGPL-3.0-only']
  s.files        = `git ls-files`.split("\n")
  # s.files = [
  #   "lib/cancancan_js.rb",
  #   "lib/cancancan_js/cancancan_export.rb",
  #   "vendor/assets/javascripts/cancancan_js.js",
  # ]
  s.require_paths = ["lib"]
  s.homepage = 'https://github.com/danabr75/cancancan_js'
  s.add_runtime_dependency 'cancancan', '>= 3.0'
  s.add_development_dependency 'cancancan', '>= 3.0'
  s.required_ruby_version = '>= 2.7'
end