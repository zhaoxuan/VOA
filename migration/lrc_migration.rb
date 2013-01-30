#encoding: utf-8
require File.expand_path('../migration_conf', __FILE__)

class CreateLrcTable < ActiveRecord::Migration
  def self.up
    create_table :lrcs do |t|
      t.string :file_name
      t.string :time
      t.text :content
      t.integer :words
      t.integer :chars
      t.integer :spaces
      t.integer :punctuations
    end

  end

  def self.down
    drop_table :lrcs
  end
end

CreateLrcTable.up