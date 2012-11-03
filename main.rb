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
    agent.download_english(download_url)
    logger.info("download success")
  rescue Exception => e
    logger.error("url #{download_url}")
  end
  
end

