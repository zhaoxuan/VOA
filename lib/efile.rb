# encoding: utf-8

class Efile
  
  def initialize
    # @download_url = 'http://down.51voa.com/201210/se-ed-mali-education-web-24oct12.mp3'
  end

  def download(url, path = 'download_file/')
    filename = @download_url[@download_url.rindex('/')+1, @download_url.length-1]

    download_file = File.new("./#{path}" + filename, 'w+')
    download_file.binmode
    download_file << open(@download_url).read
    download_file.flush
    download_file.close
  end

  def self.get_filename(url)
    url[url.rindex('/')+1, url.length-1]
  end

  def self.download(url, path = 'download_file/')
    return false if url.nil?

    filename = self.get_filename(url)

    download_file = File.new("./#{path}" + filename, 'w+')
    download_file.binmode
    download_file << open(url).read
    download_file.flush
    download_file.close
    return true
    
  end

  def self.download_content(content, title, path)
    # debugger
    filename  = self.get_filename(title).gsub(/.mp3/, '.txt')
    file_path = File.expand_path("../../download_file/content/#{filename}", __FILE__)
    download_file = File.new(file_path, 'w+')
    download_file.write(content)
    download_file.close
  end
  
end