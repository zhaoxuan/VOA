require './../lib/efile.rb'
require 'debugger'

input_path = ARGV.first

if File.directory?(input_path)
  Dir.foreach(input_path) do |file|

    next if (file[0] == "." or
      file[file.rindex('.')+1, file.length-1] == 'mp3' or
      file[-4, 4] == 'utf8')

    Efile.gbk_to_utf8(input_path + '/' + file)
  end
end