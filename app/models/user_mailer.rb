class UserMailer < ActionMailer::Base
  include ExtrasHelper
=begin  no use for now

=end
# ■　-------------------------------------
    def auto_mail
      Time.zone = 'Tokyo'
      #	extract_ymls_to_zip #see helper
      sqlite_to_zip #see helper
      recipients "taiju.emu@gmail.com, ylinko@gmail.com"
      subject "AURORA-MAIL-#{Time.zone.now.to_s(:db)}"   
      from "EMU-AURORA（server:AURORA）<ikuro.yasui@gmail.com>"
      content_type "multipart/alternative"
      
      part "text/html" do |p|
      	p.body = render_message("auto_mail_html",:message => "<h1>text contents</h1>")
  	  end
  	  
      part "text/plain" do |p|
      	p.body = render_message("auto_mail_plain",:message => "text contents")
  	  end
  	  # ■　sqlite本体
      attachment(:content_type => "application/sqlite3",
        :body => File.read(RAILS_ROOT+'/db/production.sqlite3'),       
        :filename => "production.sqlite3")
  	  # ■　sqlite圧縮
      attachment(:content_type => "application/zip",
        :body => File.read(RAILS_ROOT+'/db/production.sqlite3.zip'),       
        :filename => "production.sqlite3.zip")
  	  # ■　fixtures圧縮
    end	
    
# ■　-------------------------------------changed from this
    def auto_mail_original
    	extract_ymls_to_zip #see helper
      recipients "ikuro.yasui@gmail.com, ylinko@gmail.com"
      subject "B_R_ONCO-MAIL-#{Time.zone.now.to_s(:db)}"   
      from "EMU-BRONCO（server:BRONCO）<ikuro.yasui@gmail.com>"
      content_type "multipart/alternative"
      
      part "text/html" do |p|
      	p.body = render_message("auto_mail_html",:message => "<h1>text contents</h1>")
  	  end
  	  
      part "text/plain" do |p|
      	p.body = render_message("auto_mail_plain",:message => "text contents")
  	  end
  	  # ■　sqlite本体
      attachment(:content_type => "application/sqlite3",
        :body => File.read(RAILS_ROOT+'/db/production.sqlite3'),       
        :filename => "production.sqlite3")
  	  # ■　sqlite圧縮
      attachment(:content_type => "application/zip",
        :body => File.read(RAILS_ROOT+'/db/production.sqlite3.zip'),       
        :filename => "production.sqlite3.zip")
  	  # ■　fixtures圧縮
      attachment(:content_type => "application/zip",
        :body => File.read(RAILS_ROOT+'/test/fixtures/test.zip'),        
        :filename => "test-#{Time.now.to_date}.zip")
    end	    
    
# ■　-------------------------------------/home/taijurai/jjaux/test/fixtures/test.zip
    def auto_mail_to_kjg
      extract_ymls_to_zip #see helper
      recipients "taiju.kjg4351@gmail.com"
      subject "BRONCO-MAIL-#{Time.zone.now.to_s(:db)}"   
      from "EMU-BRONCO<ikuro.yasui@gmail.com>"
      content_type "multipart/alternative"
      
      part "text/html" do |p|
      	p.body = render_message("auto_mail_html",:message => "<h1>text contents</h1>")
  	  end
  	  
      part "text/plain" do |p|
      	p.body = render_message("auto_mail_plain",:message => "text contents")
  	  end
  	  # ■　sqlite本体
      attachment(:content_type => "application/sqlite3",
        :body => File.read(RAILS_ROOT+'/db/production.sqlite3'),       
        :filename => "production.sqlite3")
  	  # ■　sqlite圧縮
      attachment(:content_type => "application/zip",
        :body => File.read(RAILS_ROOT+'/db/production.sqlite3.zip'),       
        :filename => "production.sqlite3.zip")
  	  # ■　fixtures圧縮
      attachment(:content_type => "application/zip",
        :body => File.read(RAILS_ROOT+'/test/fixtures/test.zip'),        
        :filename => "test-#{Time.now.to_date}.zip")    
    end	
end 

=begin ■　ＨＴＭＬ形式 
   
      part "text/html" do |p| 
        p.body = render_message(
        　　　　　　　　　　"welcome_email_html", 
        　　　　　　　　　　:message => "<h1>HTML content</h1>"
        　　　　　　　　)     	
      end  
=end 
=begin ■　ＰＤＦファイルの添付方法（トラブルの回避方法）
      attachment :content_type => "image/jpeg",
        :body => File.read("taiju.jpg")  
------------------------------------------
Re: Re: Attach a PDF File to an Email - WORKAROUND
Posted by Luke Pearce (kule)
on 02.12.2007 20:23

In case someone else comes across this issue (corrupt email 
attachments).

It is a bin mode property problem as Rimantas suggests. By default 
File.read on linux will open in Binary mode in Windows it will open in 
Text mode.

To fix just change file.read to the following:

attachment "application/pdf" do |a|
  a.filename = File.basename(file_path)
  File.open(file_path, 'rb') do |file|
    a.body = file.read
  end
end

The 'rb' option opens the file in binary mode - see here for other 
options:

http://ruby-doc.org/core/classes/IO.html

Cheers
Luke
------------------------------------------------
=end 
   