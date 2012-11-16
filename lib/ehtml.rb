#encoding: utf-8
require 'rubygems'
require 'debugger'
require 'mechanize'
require File.expand_path("../efile", __FILE__)

class Ehtml

  def initialize
    @agent                  = Mechanize.new
    @agent.user_agent_alias = 'Mac Safari'
  end

  def get_page(page_url)
    @agent.get(page_url)   
  end

  def get_article_array(page)
    result = []

    page.search("//div[@id='rightContainer']/span[@id='list']/ul").children.each do |v|
        result << v.children.last.attribute('href').content
    end
    result
  end

  def get_download_url(page)
    page.search("//div[@id='menubar']").children[1].attribute('href').content
  end

  def download(url)
    Efile.download(url)
  end

  def get_caption_url(page)
    "http://www.51voa.com" + page.search('//*[@id="menubar"]/a[2]').attribute('href').content
  end

  def get_content(page)
    page.search('//*[@id="content"]').text
  end

 




end