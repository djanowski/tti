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

    CGI.stub!(:escape).with('tmp/With spaces.png').and_return('tmp/With+spaces.png')
    Tti.new('With spaces').to_html.should have_tag('img[@src=tmp/With+spaces.png]')
  end

  describe "Configuration" do
    
    it "allows to configure a path prefix to save images" do
      Tti.configure do |config|
        config.path_prefix = "tmp/path"
      end

      lambda { @tti.save }.should create_file('tmp/path/Hello.png')
      
      CGI.stub!(:escape).with('tmp/path/Hello.png').and_return('tmp/path/Hello.png')
      @tti.to_html.should have_tag('img[@src=tmp/path/Hello.png]')
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
