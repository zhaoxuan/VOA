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
  # get_article_arra 返回一个 二维数组，里面第一个元素是页面上听力的类型，第二个是标题，第三个是页面的url
  type  = donload_info[0]
  title = donload_info[1]
  link  = donload_info[2]

  begin
    page  = agent.get_page(link)

    caption_url  = URI.encode(agent.get_caption_url(page), '[]')
    download_url = URI.encode(agent.get_download_url(page), '[]')

    if caption_url.nil?
      agent.get_content page
      agent.download(download_url, "download_file/english/") unless download_url.nil?
    else
      agent.download(caption_url, "download_file/english_lrc/")
      agent.download(download_url, "download_file/english_lrc/")
    end

    logger.info("success")
  rescue Exception => e
    logger.error("can not download title: #{title} link: #{link} error: #{e}")
  end
  
end

