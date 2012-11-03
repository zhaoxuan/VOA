#encoding: utf-8
require 'rubygems'
require 'ehtml'

describe Ehtml, "ehtml" do
  
  it "get page" do
    agent = Ehtml.new
    page = agent.get_page('http://www.51voa.com/')
    page.title.should eq('美国之音-VOA听力下载,慢速英语,常速英语')

  end

  it "should get an array in home page" do
    agent = Ehtml.new

    home_page = agent.get_page('http://www.51voa.com/')

    agent.get_article_array(home_page).class.should eq(Array)
    agent.get_article_array(home_page).size.should eq(43)

  end

  it "should get a download url in a article page" do
    agent         = Ehtml.new
    download_page = agent.get_page('http://www.51voa.com/VOA_Special_English/medical-experts-debate-value-of-alcohol-use-47357.html')

    agent.get_download_url(download_page).class.should eq(String)
  end

  it "should download an english mp3 with a url" do
    agent         = Ehtml.new
    download_page = agent.get_page('http://www.51voa.com/VOA_Special_English/medical-experts-debate-value-of-alcohol-use-47357.html')
    url           = agent.get_download_url(download_page)
    
    agent.download_english(url)
  end



end