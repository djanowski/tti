Gem::Specification.new do |s|
  s.name = 'tti'
  s.version = '0.4.0'
  s.summary = %{A Ruby text-to-image generation class.}
  s.description = %{}
  s.date = %q{2008-06-25}
  s.author = "Damian Janowski"
  s.email = "damian.janowski@gmail.com"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.files = ["lib/configurable.rb", "lib/tti/helper.rb", "lib/tti.rb", "rails/init.rb", "README"]

  s.require_paths = ["lib", "lib/tti"]

  s.extra_rdoc_files = ["README"]
  s.has_rdoc = true
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "tti", "--main", "README"]
end

