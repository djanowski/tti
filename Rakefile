require 'rake'
require 'rake/gempackagetask'
require 'rake/clean'
require 'spec/rake/spectask'

gem_spec = eval(File.read('tti.gemspec'))

Rake::GemPackageTask.new(gem_spec) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = false
  rm_f FileList['pkg/**/*.*']
end

task :default => :spec

desc "Run all specs"
Spec::Rake::SpecTask.new(:spec) do |t|
  # t.spec_opts = ['--options', "\"spec/spec.opts\""]
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc "Generate the gemspec file."
task :gemspec do
  require 'erb'

  File.open('tti.gemspec', 'w') do |f|
    f.write ERB.new(File.read('tti.gemspec.erb')).result(binding)
  end
end
