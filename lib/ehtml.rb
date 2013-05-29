#encoding: utf-8
require File.expand_path("../efile", __FILE__)

class Ehtml

  def initialize
    @agent                  = Mechanize.new
    @agent.user_agent_alias = 'Mac Safari'
  end

  def get_page(page_url)
    @agent.get(page_url)   
  end

  def get_article_array(page)
    result = []

    page.search("#list//li").each do |v|
      #分类
      #标题
      #连接
      result << [
                  v.children[0].content,
                  v.children.last.content,
                  v.children.last.attribute('href').content
                ]
    end
    result
  end

  def get_download_url(page)
    if page.search("//div[@id='menubar']").children[1].nil?
      return nil
    else
      page.search("//div[@id='menubar']").children[1].attribute('href').content
    end
  end

  def download(url, path)
    Efile.download(url, path)
  end

  def get_caption_url(page)
    second_menubar = page.search('//*[@id="menubar"]/a[2]')
    if second_menubar.length == 0
      return nil
    else
      if second_menubar.attribute('target').nil?
        return "http://www.51voa.com" + second_menubar.attribute('href').content
      else
        return nil
      end
    end
  end

  def get_content(page)
    page.search('//*[@id="content"]').text.gsub(/\\s*|\r|\n/, '')
  end

  def save_content(content, title, path)
    Efile.download_content(content, title, path)
  end

 

end