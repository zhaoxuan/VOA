#encoding: utf-8
require File.expand_path("../data_conf", __FILE__)

class Lrc < ActiveRecord::Base
  def analyze_file(file)
    last_time = '00:00.00'
    filename  = file[file.rindex('/')+1, file.length-1]
    lines     = []

    File.foreach(file) do |line|
      next unless effective_line(line)
      time, content = effective_line(line)
      time = format_time(time).round(2)
      duration = lines.size > 0 ? (time - lines[-1][:time]) : 0
      words_number, spaces_number, punctuations_number, chars = count_words(content)

      lines << {
                :file_name => filename,
                :time => time,
                :duration => duration,
                :content => content,
                :words => words_number,
                :chars => chars,
                :spaces => spaces_number,
                :punctuations => punctuations_number
              }
    end

    if lines.first['duration'] == 0
      lines.first['duration'] = lines[1]['time'] - lines[0]['time']
    end

    lines.each do |lrc|
      Lrc.create(lrc)
    end
    return true
  end



  private
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

  def format_time(string)
    minute = /\d\d/.match(string)[0]
    second = /\d\d\.\d\d/.match(string)[0]
    return minute.to_f * 60 + second.to_f
  end



end