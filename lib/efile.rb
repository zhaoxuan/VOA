# encoding: utf-8
require 'rubygems'
require 'open-uri'
require 'debugger'

class Efile
  
  def initialize
    @download_url = 'http://down.51voa.com/201210/se-ed-mali-education-web-24oct12.mp3'
  end

  def download(url)
    filename = @download_url[@download_url.rindex('/')+1, @download_url.length-1]

    download_file = File.new("./download_file/" + filename, 'w+')
    download_file.binmode
    download_file << open(@download_url).read
    download_file.flush
    download_file.close
 
  end

  def self.download(url)
    filename = url[url.rindex('/')+1, url.length-1]

    download_file = File.new("./download_file/" + filename, 'w+')
    download_file.binmode
    download_file << open(url).read
    download_file.flush
    download_file.close
  end
  
end