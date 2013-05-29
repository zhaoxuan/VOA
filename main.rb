#encoding: utf-8
require 'rubygems'
require 'logger'
require 'debugger'
require 'open-uri'
require 'mechanize'
require 'mp3info'
require File.expand_path("../lib/ehtml", __FILE__)
require File.expand_path("../models/lrc", __FILE__)

ROOT_PATH = File.expand_path('../', __FILE__)

def analyze
  lrc_dir = File.expand_path("../download_file/english_lrc", __FILE__)
  if File.directory?(lrc_dir)
    efile = Efile.new
    
    Dir.foreach(lrc_dir) do |file|
      next if file[0] == "." or file[file.rindex('.')+1, file.length-1] == 'mp3'
      
      begin
        p file
        efile.analyze_lrc(lrc_dir + '/' + file)
        $log1.info("analyze lrc file success ")
      rescue Exception => e
        $log1.error(e)
        $log1.error(file)
      end
    end
   

  end
end

def download_voa
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

      page     = agent.get_page(link)
      caption  = agent.get_caption_url(page)
      download = agent.get_download_url(page)

      if caption.nil? && download.nil?
        logger.info("not mp3 file！ title: #{title} link: #{link} ")
        next
      end

      if caption.nil?
        content = agent.get_content(page)
        agent.save_content(content, URI.encode(download, '[]'), 'download_file/content')
        agent.download(URI.encode(download, '[]'), "download_file/english/") unless download.nil?
      else
        agent.download(URI.encode(caption, '[]'), "download_file/english_lrc/") unless caption.nil?
        agent.download(URI.encode(download, '[]'), "download_file/english_lrc/") unless download.nil?
      end

      logger.info("success")
    rescue Exception => e
      logger.error("can not download title: #{title} link: #{link} error: #{e}")
    end
  end
end

$log1 = Logger.new("log/development.log")

case ARGV.first
when '-d'
  download_voa

when '-a'
  source_dir      = File.expand_path("../download_file/content", __FILE__)
  destination_dir = File.expand_path("../download_file/clean_content", __FILE__)
  
  Efile.new.modify_each_file(source_dir, destination_dir)
when 'analyze'
  analyze

end


  
