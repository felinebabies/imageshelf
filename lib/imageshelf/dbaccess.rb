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

    end
end