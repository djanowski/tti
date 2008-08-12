require 'rubygems'
require 'spec'
require 'active_support'

begin
  require 'action_controller'
  require 'action_view'
  $rails = true
rescue LoadError => e
  
end

require 'html/document'
require 'rspec_hpricot_matchers'
require 'fileutils'

require File.dirname(__FILE__) + '/../lib/tti'

Spec::Runner.configure do |config|
  config.include(RspecHpricotMatchers)
end

def create_file(name)
  FileUtils.rm_rf(name) rescue nil
  change { File.exist?(name) }.from(false).to(true)
end

def add_method(klass, method)
  change { klass.new.respond_to?(method) }.from(false).to(true)
end

def configuring(klass, &block)
  # TODO: Forget the config after the assertion.

  lambda do
    klass.configure(&block)
  end
end
