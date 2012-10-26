#encoding: utf-8
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'ehtml'

describe Ehtml, "ehtml" do
  
  it "get home page" do
    h_page = Ehtml.new
    debugger
    h_page.get_home_page
  end



end