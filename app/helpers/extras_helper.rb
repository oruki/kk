module ExtrasHelper
	
  def  extract_ymls_to_zip
  	# 01 extract
  	extract_fixture
  	# 02 zip
    ymls_to_zip
    sqlite_to_zip
  end	

  def ymls_to_zip
    ymls = Dir.glob(RAILS_ROOT+'/test/fixtures/*.yml') #ymlファイルのファイル名称一覧
    zip_file = RAILS_ROOT+'/test/fixtures/test.zip'    #作成する圧縮ファイルの名前
    if File.exist?(zip_file)
      File.delete(zip_file) #古いファイルは先にに削除する
    else
      File.open(RAILS_ROOT+'/test/fixtures/test.zip', "w") #書き込み専用でファイルを開く（新規作成）
    end

    Zip::Archive.open(zip_file, Zip::CREATE) do |arc|
      ymls.each{|f| arc.add_file(f) }
    end
    #redirect_to :back
  end

  def sqlite_to_zip
    sq = Dir.glob(RAILS_ROOT+'/db/*.sqlite3') #ysqlite3 ファイルのファイル名称一覧
    zip_file = RAILS_ROOT+'/db/production.sqlite3.zip'    #作成する圧縮ファイルの名前
    if File.exist?(zip_file)
      File.delete(zip_file) #古いファイルは先にに削除する
    else
      File.open(RAILS_ROOT+'/db/production.sqlite3.zip', "w") #書き込み専用でファイルを開く（新規作成）
    end
    Zip::Archive.open(zip_file, Zip::CREATE) do |arc|
      sq.each{|f| arc.add_file(f) }
    end
    #redirect_to :back
  end
  
  def extract_fixture
      fixtures_dir = db_connection

      tables = {}
      table = []
      open("#{RAILS_ROOT}/db/schema.rb") do |file|
        while line = file.gets
          next if line.blank?
          case line
          when /create_table/
            table = []
            table << line.split(/"/)[1]
            has_id = line.split(/,/).detect { |l| /:id => false/ =~ l }
            table << "id" unless has_id
          when /t\./
            column = line.split(/"/)[1]
            table << column unless /created_at|updated_at/ =~ column
          when /  end/
            tables[table.shift] = table unless table.blank?
          end
        end
      end
      tables.delete("sessions")
      tables.each do |table_name, columns|
        next if ENV["FIXTURES"] && !ENV["FIXTURES"].split(/,/).include?(table_name)
        order = columns.include?("id") ? " ORDER BY id" : ""
        records = execute_sql(table_name, order)
        next if records.empty?
        write_fixtures(
          fixtures_dir + table_name, records, columns
          ) {
          |record, column, i| entry_fixture(column, record[column])
          }
      end
      #redirect_to :action => 'index'
  end 

private

	def db_connection(db = nil)
	  ActiveRecord::Base.establish_connection(db)
	  fixtures_dir = RAILS_ROOT + "/"
	  fixtures_dir += File.exist?(fixtures_dir + "spec") && !exist_module? ? "spec" : "test"
	  fixtures_dir += "/fixtures/"
	  FileUtils.mkdir_p(fixtures_dir)
	  fixtures_dir
	end
	
	def execute_sql(table_name, order)
	  sql = "SELECT * FROM %s" + order
	  ActiveRecord::Base.connection.select_all(sql % table_name)
	end
	
	def write_fixtures(file_name, records, columns, mode = "w")
	  yaml = "#{file_name}.yml"
	  i = 0
	  
	  if File.exist?(yaml)
	    open(yaml) do |file|
	      while line = file.gets
	        i += 1 if /^data/ =~ line
	      end
	    end
	  end
	
	  open(yaml, mode) do |file|
	    records.each do |record|
	      rec = ["data#{i += 1}:"]
	      columns.each do |column|
	        r = yield record, column, i
	        rec << r
	      end
	      file.write rec.compact.join("\n") + "\n" * 2
	    end
	  end
	end
	
	def entry_fixture(column, value)
	  if value.nil? || (value == "0" && column =~ /_id$|^type$/)
	    nil
	  else
	    return unless value.class == String
	    value.gsub!(/\t|\?/, "")
	    value.gsub!(/\[/, "［")
	    value.gsub!(/\]/, "］")
	    if value =~ /\n/
	      "  #{column}: |\n    " + value.split("\n").join("\n    ")
	    else
	      "  #{column}: #{value}"
	    end
	  end
	end
	
	def exist_module?
	  mod = "FantasistaModule"
	  File.exist?("#{RAILS_ROOT}/lib/#{mod.underscore}.rb") ? mod.constantize : false
	end
	
end	