require 'rubygems'
require 'RMagick'
require 'fileutils'
require 'uri'
require 'cgi'
require 'active_support'
require File.dirname(__FILE__) + '/configurable'

class Tti
  include Configurable

  attr_accessor :text, :width, :font_size

  def initialize(text)
    @text = text

    yield(self) if block_given?
  end

  def text
    @text.to_s
  end

  def font_size
    @font_size ||= config.font_size
  end

  def save
    return if text.blank?

    width = width_or_computed
    font, size = self.font_file, self.font_size
    
    Magick::Image.read("caption:#{text}") do |i|
      i.size = width
      i.font = font
      i.pointsize = size
      i.antialias = true
    end.first.write(path)

    self
  end

  def filename
    opts = []
    opts << font unless font == 'Helvetica'
    opts << "#{font_size}pt" unless font_size == config.font_size
    opts << width if width_set?

    "#{text}%s.png" % (!opts.empty? ? "@#{opts.join('__')}" : '')
  end

  def path
    FileUtils.mkdir_p(config.path_prefix) if config.path_prefix
    File.join(*[config.path_prefix, filename].compact)
  end

  def url
    CGI.escape [config.url_prefix || config.path_prefix, filename].join('/')
  end

  def width_or_computed
    width_set? ? width : computed_width
  end

  def width_set?
    !(width.nil? || width.zero?)
  end

  def computed_width
    @computed_width ||= begin
      canvas = Magick::Image.new(1,1)

      font, size = self.font_file, self.font_size

      metrics = Magick::Draw.new.annotate(canvas, 0, 0, 0, 0, text) do |i|
        i.pointsize = size
        i.font = font
        # i.gravity = Magick::CenterGravity
      end.get_type_metrics(canvas, text)

      metrics.width.ceil
    end
  end

  def font
    @font ||= config.font || 'Helvetica'
  end

  def to_html
    save
    %{<img src="#{url}" alt="#{text}" />}
  end

  def font_file
    file = Dir["#{font}.*"].first || Dir["fonts/#{font}.*"].first

    file ? File.join(Dir.pwd, file) : font
  end

  configure do |config|
    config.path_prefix = 'tmp'
    config.font_size = 24
  end
end
