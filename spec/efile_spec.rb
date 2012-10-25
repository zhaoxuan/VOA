# encoding: utf-8
require 'rubygems'
require 'efile'

describe Efile, "efile" do

  it "shoud download file" do
    efile = Efile.new
    efile.download
  end

end