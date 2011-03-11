#Q108 p276
#Also reffer to http://www.yotabanana.com/hiki/ja/ruby-gettext-howto-ror.html?ruby-gettext-howto-ror#Rakefile
#http://www.yotabanana.com/lab/20060914.html  と質問がありました。これは以下のようにすると回避できます。
#requireを限定的におこなう？

desc "Update pot/po files."
task :updatepo do
  require 'gettext/utils'  #Here!
  GetText.update_pofiles("blog", Dir.glob("{app,lib,bin}/**/*.{rb,rhtml}"), "blog 1.0.0")
end
 
desc "Create mo-files"
task :makemo do
  require 'gettext/utils'  #Here!
  GetText.create_mofiles(true, "po", "locale")
end 