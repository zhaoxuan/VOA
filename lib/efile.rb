# encoding: utf-8

class Efile
  
  def initialize
    # @download_url = 'http://down.51voa.com/201210/se-ed-mali-education-web-24oct12.mp3'
  end

  def effective_line(line)
    regexp = /\[\d\d:\d\d.\d\d\]/.match(line)
    return false if regexp.nil?

    time    = /\d\d:\d\d.\d\d/.match(regexp[0])[0]
    content = regexp.post_match
    words   = count_words(content)
  end

  def count_words(string)
    words = string.split(/\b/)

    words_number  = 0
    spaces_number = 0

    words.each do |word|
      p word
      if word == ' '
        spaces_number = spaces_number + 1
      else
        words_number = words_number + 1
      end
    end
    return words_number
  end

  def count_chars(string)
    chars = string.split(/./)
  end

  def analyze_lrc(file)
    lrc_file = 

    # File.foreach(file) do |line|
    #   # p line
    # end
    []
  end

  def clean_content(content)
    regexp =  /Player\(.*\;/.match(content)
    {
      'name' => regexp[0],
      'body' => regexp.post_match
    }
  end

  def modify_each_file(source_dir, destination_dir)
    if File.directory?(source_dir)
      directory_or_create(destination_dir)

      Dir.foreach(source_dir) do |file|
        next if file == "." || file == ".." || file == ".DS_Store"
        path     = File.join(source_dir, file)
        new_path = File.join(destination_dir, file)
        content  = File.read(path)
        new_file = File.new(new_path, 'w+')

        clean_content(content).each do |k, v|
          new_file.puts(v)
        end
        
        new_file.close
      end
    end
  end

  def directory_or_create(destination_dir)
    Dir.mkdir(destination_dir) unless File.exist?(destination_dir)
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
    filename  = self.get_filename(title).gsub(/.mp3/, '.txt')
    file_path = File.expand_path("../../download_file/content/#{filename}", __FILE__)
    download_file = File.new(file_path, 'w+')
    download_file.write(content)
    download_file.close
  end
  
end