
# UTF-8 without BOM don't check BOM in editor
#! /usr/local/bin/ruby
  require 'rubygems'
  require 'zipruby'
    ymls = Dir.glob('/home/oruki/jj/test/fixtures/*.yml') #ymlファイルのファイル名称一覧
    zip_file = '/home/oruki/jj/test/fixtures/test.zip'    #作成する圧縮ファイルの名前
    if File.exist?(zip_file)
      File.delete(zip_file) #古いファイルは先にに削除する
    else
      File.open("/home/oruki/jj/test/fixtures/test.zip", "w") #書き込み専用でファイルを開く（新規作成）
    end
    Zip::Archive.open(zip_file, Zip::CREATE) do |arc|
      ymls.each{|f| arc.add_file(f) }
    end
#   redirect_to :back
# end