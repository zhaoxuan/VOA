#encoding: utf-8
require 'rubygems'
require 'bundler/setup'
require 'open-uri'
require 'mp3info'

Bundler.require
ROOT_PATH = File.expand_path('../', __FILE__)
Dir.glob(ROOT_PATH + '/lib/*.rb') {|lib_file| require lib_file}
Dir.glob(ROOT_PATH + '/models/*.rb') {|lib_file| require lib_file}

# To set ruby encoding to utf-8
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

def analyze
  log = Logger.new("log/analyze.log")
  lrc_dir = File.expand_path("../download_file/english_lrc", __FILE__)
  if File.directory?(lrc_dir)
    efile = Efile.new

    Dir.foreach(lrc_dir) do |file|
      next if file[0] == "." or file[file.rindex('.')+1, file.length-1] == 'mp3'

      begin
        efile.analyze_lrc(lrc_dir + '/' + file)
        log.info("analyze lrc file success ")
      rescue Exception => e
        log.error(e)
        log.error(file)
      end
    end


  end
end

def download_voa
  agent     = Ehtml.new
  home_page = agent.get_page('http://www.51voa.com/')
  logger    = Logger.new("log/development.log")
  logger.datetime_format = "%Y-%m-%d %H:%M:%S"

  agent.get_article_array(home_page).each do |download_info|
    # get_article_arra 返回一个 二维数组，里面第一个元素是页面上听力的类型，第二个是标题，第三个是页面的url
    type  = download_info[0]
    title = download_info[1]
    link  = download_info[2]

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
      send_mail({'suject' => "download voa error", 'body' => "#{e.backtrace.join("\n")}"})
      logger.error("can not download title: #{title} link: #{link} error: #{e}")
    end
  end
end

def hist_downlaod(download_num = 1)
  url = "http://www.51voa.com/VOA_Standard_#{download_num}.html"
  agent     = Ehtml.new
  home_page = agent.get_page(url)
  logger    = Logger.new("log/development.log")
  logger.datetime_format = "%Y-%m-%d %H:%M:%S"

  agent.hist_article_array(home_page).each do |download_info|
    type  = download_info[0]
    title = download_info[1]
    link  = download_info[2]

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



include Mailer

case ARGV.first
when '-h'
  # download history data
  hist_downlaod

when '-d'
  # download home page data
  download_voa
  send_mail({'subject' => 'VOA download mail', 'body' => "Today #{Time.now} task has completed"})

when '-a'
  # analyse html, when it is without lrc file
  source_dir      = "#{ROOT_PATH}/download_file/content"
  destination_dir = "#{ROOT_PATH}/download_file/clean_content"

  Efile.new.modify_each_file(source_dir, destination_dir)
when 'analyze'
  analyze

when '-m'
  send_mail({'suject' => "mailer from pi", 'body' => "This is pi."})
end



