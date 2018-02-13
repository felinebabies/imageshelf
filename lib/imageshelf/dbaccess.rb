require 'imageshelf'

module Imageshelf
    module Dbaccess
      module_function

      DB_DEFINITION = [
        { ver: 0, sql: <<-SQL },
create table imageshelfver (
  version number primary key
);
SQL
        { ver: 0, sql: <<-SQL }
create table images (
  hash text not null,
  fullpath text primary key
);
SQL
      ]

      VERSION_UPDATE = <<-SQL
        INSERT OR REPLACE INTO
          imageshelfver
          (version)
        values
          (?);
      SQL

      # データベースファイルのパスを返す
      def getdbfilepath
        File.join(LocalSettings::get_root_dir, LOCAL_DATA_DIR_NAME, LocalSettings::SQLITE3DBFILE)
      end

      # データベースの初期化を行う
      def dbinit(dbfilepath)
        db = SQLite3::Database.new(dbfilepath)
        db.transaction
        begin
          DB_DEFINITION.each do |item|
            # テーブル定義を実行
            db.execute(item[:sql])

            # DBバージョン情報を登録する
            db.execute(VERSION_UPDATE, item[:ver])
          end
          db.commit
        rescue
          db.rollback
        end
  
        db.close
      end

      # 画像情報の登録、更新を行う
      def updateimages(hashmap)
        insertsql = <<-SQL
          INSERT OR REPLACE INTO
            images
          (hash, fullpath)
          values
            (?, ?);
        SQL

        db = SQLite3::Database.new(getdbfilepath)
        db.transaction do
          hashmap.each do |item|
            db.execute(insertsql, item[:hash].to_s, File::expand_path(item[:filepath]))
          end
        end
        db.close
      end

      # 登録済画像の一覧を取得する
      def getimagelist
        selectsql = <<-SQL
          SELECT
            *
          FROM
            images;
        SQL
        
        db = SQLite3::Database.new(getdbfilepath)
        db.results_as_hash = true
        imagelistarr = db.execute(selectsql)
        
        db.close

        imagelistarr
      end

    end
end