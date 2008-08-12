require File.join(File.dirname(__FILE__), 'spec_helper')

describe Tti do
  
  before(:each) do
    @tti = Tti.new('Hello')
  end

  it "generates an image file out of text" do
    lambda { @tti.save }.should create_file('tmp/Hello.png')

    lambda { Tti.new('').save }.should_not raise_error
  end

  it "creates a file name for the generated image" do
    @tti.filename.should == 'Hello.png'
  end

  it "calculates the necessary width" do
    @tti.width.should_not == 0
  end

  it "has a default typeface" do
    @tti.font.should_not be_blank
  end

  it "generates an HTML tag for the generated image" do
    @tti.to_html.should have_tag('img[@alt=Hello]')

    Tti.new('With spaces').to_html.should have_tag('img[@src=tmp%2FWith+spaces.png]')
  end

  it "generates text in different font sizes" do
    another_tti = Tti.new('Hello')
    another_tti.font_size = 36
    
    @tti.save
    another_tti.save

    File.read(@tti.path).should_not == File.read(another_tti.path)
  end

  describe "Configuration" do
    
    it "allows to configure a path prefix to save images" do
      Tti.configure do |config|
        config.path_prefix = "tmp/path"
      end

      lambda { @tti.save }.should create_file('tmp/path/Hello.png')
      
      @tti.to_html.should have_tag('img[@src=tmp%2Fpath%2FHello.png]')
    end

    it "allows to configure a URL prefix for generated HTML" do
      Tti.configure do |config|
        config.url_prefix = "some/url"
      end

      @tti.to_html.should have_tag('img[@src=some%2Furl%2FHello.png]')
    end

    it "allows to configure a default font name" do
      @tti.save

      Tti.configure do |config|
        config.font = 'chopin'
      end

      another_tti = Tti.new('Hello')
      another_tti.save

      File.read(another_tti.path).should_not == File.read(@tti.path)
    end

    it "allows to configure a default font size" do
      configuring Tti do |config|
        config.font_size = 12
      end.should change { File.read(Tti.new('Hello').save.path) }
    end

  end

  describe "as a Rails plugin" do

    it "provides a helper to ActionView" do
      lambda { require 'rails/init' }.should add_method(ActionView::Base, :tti)

      Tti.stub!(:new).and_return(mock('Tti', :to_html => 'html'))
      ActionView::Base.new.tti.should == 'html'
    end

    it "saves images to the correct Rails path" do
      require 'rails/init'
      Tti.configuration.path_prefix.should == 'public/images/tti'
    end

  end if $rails

end
