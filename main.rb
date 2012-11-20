#encoding: utf-8
require 'rubygems'
require 'logger'
require 'debugger'
require 'open-uri'
require 'mechanize'

require File.expand_path("../lib/ehtml", __FILE__)

agent     = Ehtml.new
home_page = agent.get_page('http://www.51voa.com/')
logger    = Logger.new("log/development.log")
logger.datetime_format = "%Y-%m-%d %H:%M:%S"

agent.get_article_array(home_page).each do |donload_info|

  type = donload_info[0]
  title = donload_info[1]
  link = donload_info[2]
  begin
    page  = agent.get_page(link)

    caption_url  = agent.get_caption_url(page)
    download_url = agent.get_download_url(page)

    if caption_url.nil?
      agent.download(download_url, "download_file/english/")
    else
      debugger
      agent.download(caption_url, "download_file/english_lrc/")
      agent.download(download_url, "download_file/english_lrc/")
    end

    logger.info("download success")
  rescue Exception => e
    logger.error("can not download title: #{title} link: #{link}")
  end
  
end

