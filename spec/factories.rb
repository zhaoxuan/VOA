#spec/factories.rb
require 'factory_girl'
require File.expand_path('../../models/lrc', __FILE__)

FactoryGirl.define do
  factory :lrc do
    file_name 'file_name.lrc'
    time '00:18.52'
    content 'The move is expected to save money and ease'
    words 9
    spaces 8
    punctuations 0
    chars 43
  end
end
