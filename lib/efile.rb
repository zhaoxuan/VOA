# encoding: utf-8

class Efile

  def initialize
    # @download_url = 'http://down.51voa.com/201210/se-ed-mali-education-web-24oct12.mp3'
  end

  def count_chars(string)
    chars = string.split(/./)
  end

  def clean_content(content)
    # regexp = /Player\(.*\;/.match(content)
    # {
    #   'name' => regexp[0],
    #   'body' => regexp.post_match
    # }
    {
      'name' => '',
      'body' => content
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

  def self.get_filename(url)
    url[url.rindex('/')+1, url.length-1]
  end

  def self.download(url, path = 'download_file/')
    return false if url.nil?

    filename = self.get_filename(url)
    path = ROOT_PATH + '/' + path

    self.wget({'directory' => path, 'url' => url, 'out_file' => path+filename})

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

      gbk_to_utf8(out_file, ROOT_PATH + '/download_file/english_lrc') if url[-3, 3] == 'lrc'
    rescue Exception => e
      if times == 0
        raise e
      else
        retry
      end
    end
  end

  def self.gbk_to_utf8(input_file, out_dir)
    file = Pathname.new(input_file)
    f = File.new(out_dir + '/' + file.basename.to_s, 'w+')
    f.write File.open(input_file).read.encode("utf-8", "gbk")
    f.close
  end

  def self.download_content(content, title, path)
    filename  = self.get_filename(title).gsub(/.mp3/, '.txt')
    file_path = File.expand_path("../../download_file/content/#{filename}", __FILE__)
    download_file = File.new(file_path, 'w+:UTF-8')
    download_file.write(content)
    download_file.close
  end
  
end