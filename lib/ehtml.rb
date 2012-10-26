#encoding: utf-8
require 'rubygems'
require 'debugger'

class Ehtml
  
  def html_search
    
    
  end

  def get_home_page
    @home_page_html = Nokogiri::HTML(open('http://www.51voa.com/'))
    @home_page_html.xpath('//span[@id="list"]/ul').each do |v|
      
    end  
  end




end