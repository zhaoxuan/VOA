# encoding: utf-8

class Efile

  def initialize
    # @download_url = 'http://down.51voa.com/201210/se-ed-mali-education-web-24oct12.mp3'
  end

  def format_time(string)
    minute = /\d\d/.match(string)[0]
    second = /\d\d\.\d\d/.match(string)[0]
    return minute.to_f * 60 + second.to_f
  end

  def effective_line(line)

    ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
    valid_string = ic.iconv(line.force_encoding("UTF-8"))
    regexp = /\[\d\d:\d\d.\d\d\]/.match(valid_string)
    return false if regexp.nil?

    time    = /\d\d:\d\d.\d\d/.match(regexp[0])[0]
    content = regexp.post_match
    return time, content
  end

  def count_words(string)
    words = string.split(/\b/)

    words_number        = 0
    spaces_number       = 0
    punctuations_number = 0

    words.each do |word|
      if word == ' '
        spaces_number += 1
      elsif [',', '.', ', ', '。'].include?(word)
        punctuations_number += 1
      else
        words_number += 1
      end
    end

    return words_number, spaces_number, punctuations_number, string.size
  end

  def count_chars(string)
    chars = string.split(/./)
  end

  def analyze_lrc(file)

    filename = file[file.rindex('/')+1, file.length-1]
    File.foreach(file) do |line|
      next unless effective_line(line)
      time, content = effective_line(line)
      words_number, spaces_number, punctuations_number, chars = count_words(content)
      Lrc.create(
        :file_name => filename,
        :time => format_time(time).round(2),
        :content => content,
        :words => words_number,
        :chars => chars,
        :spaces => spaces_number,
        :punctuations => punctuations_number
      )
    end
    return true
  end

  def clean_content(content)
    regexp = /Player\(.*\;/.match(content)
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
        content  = File.open(path, :encoding => "utf-8").read
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
  
  # def download(url, path = 'download_file/')
  #   filename = @download_url[@download_url.rindex('/')+1, @download_url.length-1]
  #   path = ROOT_PATH + '/' + path

  #   download_file = File.new("./#{path}" + filename, 'w+')
  #   download_file.binmode
  #   download_file << open(@download_url).read
  #   download_file.flush
  #   download_file.close
  # end

  def self.get_filename(url)
    url[url.rindex('/')+1, url.length-1]
  end

  def self.download(url, path = 'download_file/')
    return false if url.nil?

    filename = self.get_filename(url)
    path = ROOT_PATH + '/' + path

    self.wget({'directory' => path, 'url' => url, 'out_file' => path+filename})
    # download_file = File.new("#{path}" + filename, 'w+')
    # download_file.binmode
    # download_file << open(url, 'User-Agent' => 'ruby').read
    # download_file.flush
    # download_file.close
    return true
    
  end

  def self.wget(opt = {})
    directory = opt['directory']
    url       = opt['url']
    out_file  = opt['out_file']

    times = 3
    begin
      times = times - 1
      `wget -O '#{out_file}' '#{url}'`
      raise 'wget download file error' if $?.to_i != 0
    rescue Exception => e
      if times == 0
        raise e
      else
        retry
      end
    end
  end

  def self.download_content(content, title, path)
    filename  = self.get_filename(title).gsub(/.mp3/, '.txt')
    file_path = File.expand_path("../../download_file/content/#{filename}", __FILE__)
    download_file = File.new(file_path, 'w+')
    download_file.write(content)
    download_file.close
  end
  
end