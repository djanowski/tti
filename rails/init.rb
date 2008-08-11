require File.dirname(__FILE__) + '/../lib/tti/helper'

ActionView::Base.send(:include, Tti::Helper)

Tti.configure do |config|
  config.path_prefix = 'public/images/tti'
  config.url_prefix = '/images/tti'
end
