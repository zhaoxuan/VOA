#encoding: utf-8
require 'rubygems'
require 'logger'
require 'debugger'
require File.expand_path("../lib/ehtml", __FILE__)

agent     = Ehtml.new
home_page = agent.get_page('http://www.51voa.com/')
logger    = Logger.new("log/development.log")
logger.datetime_format = "%Y-%m-%d %H:%M:%S"

agent.get_article_array(home_page).each do |download_page|

  begin
    page  = agent.get_page(download_page)
    download_url = agent.get_download_url(page)
    agent.download(download_url) unless download_url.nil?

    caption_url = agent.get_caption_url(page)
    agent.download(caption_url) unless caption_url.nil?

    logger.info("download success")
  rescue Exception => e
    logger.error("can not download #{download_page}")
  end
  
end

