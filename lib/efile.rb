# encoding: utf-8
require 'rubygems'
require 'open-uri'
require 'debugger'

class Efile
  
  def initialize
    @download_url = 'http://down.51voa.com/201210/se-ed-mali-education-web-24oct12.mp3'
  end

  def download
    filename = @download_url[@download_url.rindex('/')+1, @download_url.length-1]

    open(@download_url) do |file|
      download_file = File.new(filename, 'w+')
      download_file.binmode
      download_file << file.read
      download_file.flush
      download_file.close
      
    end
  end
  
end