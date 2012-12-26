# encoding: utf-8
require 'rubygems'
require 'efile'

describe Efile, "efile" do

  it "count words in the string" do
    efile = Efile.new
    efile.count_words('From VOA Learning English, this is the TECHNOLOGY REPORT in Special English.').should eq 9
  end

  it "analyze line string if it is time&english return [time, content, words, chars]" do
    
  end

  it "analyze line if it is not time&english return an false" do
    efile = Efile.new
    efile.effective_line("[ti:Improving 'Feed Efficiency'in Cattle]").class.should eq FalseClass
    efile.effective_line("[ar:Steve Ember]").class.should eq FalseClass
    efile.effective_line("[al:TECHNOLOGY REPORT]").class.should eq FalseClass
    efile.effective_line("[by:www.51voa.com]").class.should eq FalseClass

  end

  it "should analyze lrc file and return a array" do
    efile = Efile.new
    path  = File.expand_path('../../download_file/english_lrc/se-ag-cattle-feed-efficiency-WEB-13nov12.lrc', __FILE__)
    File.exist?(path).should eq true

    efile.analyze_lrc(path).class.should eq Array
  end

  it "should download file" do
    # efile = Efile.new
    # efile.download ""
  end

  it "should clean up content" do
    path    = File.expand_path('../../download_file/content/11bb8186-9a4c-4012-8722-8e7237d6bb7e.txt', __FILE__)
    content = File.open(path).read
    efile   = Efile.new

    response = efile.clean_content(content)
    response['name'].should eq("Player(\"/201212/11bb8186-9a4c-4012-8722-8e7237d6bb7e.mp3\");")
  end

  it "should clean up each file in the content dir" do
    dir = File.expand_path('../../download_file/content', __FILE__)
    # Dir.foreach(dir) do |file|
    #   p file
    # end
    File.exist?(dir).should eq true
    File.join(dir, '/123')
  end

end