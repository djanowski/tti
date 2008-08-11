require 'rubygems'
require 'rmagick'
require 'fileutils'
require 'active_support'
require File.dirname(__FILE__) + '/configurable'

class Tti
  include Configurable

  attr_accessor :text, :width

  def initialize(text)
    @text = text
  end

  def text
    @text.to_s
  end

  def save
    #font = "HelveticaNeueLTStd-Th.otf"

    width = width_or_computed
    font = self.font
    
    Magick::Image.read("caption:#{text}") do |i|
      i.size = width
      i.font = font
      i.pointsize = 36
      i.antialias = true
    end.first.write path
  end

  def filename
    "#{text}%s.png" % (width? ? "@#{width}" : '')
  end

  def path
    FileUtils.mkdir_p(config.path_prefix) if config.path_prefix
    File.join(*[config.path_prefix, filename].compact)
  end

  def width_or_computed
    width? ? width : computed_width
  end

  def width?
    !(width.nil? || width.zero?)
  end

  def computed_width
    @computed_width ||= begin
      canvas = Magick::Image.new(1,1)

      font = self.font

      metrics = Magick::Draw.new.annotate(canvas, 0, 0, 0, 0, text) do |i|
        i.pointsize = 24
        i.font = font
      end.get_type_metrics(canvas, text)

      metrics.width.to_i
    end
  end

  def font
    @font ||= 'Helvetica'
  end

  def to_html
    save
    %{<img src="#{CGI::escape(path)}" alt="#{text}" />}
  end

  configure do |config|
    config.path_prefix = 'tmp'
  end
end
