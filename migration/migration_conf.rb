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
module MigrationConf
  module ClassMethods
    
  end
  
  module InstanceMethods
    
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end