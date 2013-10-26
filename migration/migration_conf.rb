#encoding: utf-8
require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => "mysql",
  :host => "localhost",
  :database => "voa",
  :username => "root",
  :password => "123456",
  :encoding => 'utf8'
)