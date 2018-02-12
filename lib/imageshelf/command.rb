require 'imageshelf'
require 'digest/md5'
require 'thor'
require 'sqlite3'

module Imageshelf
  class Command < Thor
    desc "init", "カレントディレクトリをImageshelfの管理対象に設定します"
    def init
      # 既に初期化されていれば、メッセージを表示して終了
      if LocalSettings::already_init? then
        puts "このディレクトリは既にimageshelfの初期化済みです。"
        exit
      end

      puts "imageshelfの初期化中です。"

      # 初期化用データディレクトリを作成する
      FileUtils.mkdir(LOCAL_DATA_DIR_NAME)

      # データディレクトリのパスを作成
      datadir = File.join(Dir.pwd, LOCAL_DATA_DIR_NAME)

      # 初期化用DBファイルを作成する
      db = SQLite3::Database.new File.join(datadir, LocalSettings::SQLITE3DBFILE)

      # DBにテーブルを作成する
      sql = <<-SQL
        create table images (
          id integer primary key,
          hash text,
          fullpath text,
          unique(hash, fullpath)
        );
      SQL

      db.execute(sql)

      # DBに初期設定を描き込む

      puts "imageshelfの初期化を完了しました。"
    end

    desc "update", "初期化済ディレクトリ以下の画像をスキャンして、データベースを更新します"
    def update
      # 初期化されていなければ、メッセージを表示して終了
      unless LocalSettings::already_init? then
        puts "このディレクトリはImageshelfのために初期化されていません。"
        exit
      end

      # カレントディレクトリ以下のファイルのリストアップ
      files = []
      LocalSettings::IMAGE_EXTS.each do |ext|
        files.concat(Dir.glob("**/*.#{ext}"))
      end

      hashmap = files.map do |item|
        {filepath: item, hash: Digest::MD5.file(item)}
      end

      # puts hashmap

      # データベースに登録済みのファイルと比較し、更新分を登録する
      insertsql = <<-SQL
        INSERT OR REPLACE INTO
          images
        (hash, fullpath)
        values
          (?, ?);
      SQL

      db = SQLite3::Database.new File.join(LocalSettings::get_root_dir, LOCAL_DATA_DIR_NAME, LocalSettings::SQLITE3DBFILE)
      db.transaction
      begin
        hashmap.each do |item|
          db.execute(insertsql, item[:hash].to_s, File::expand_path(item[:filepath]))
        end
      rescue
        db.rollback
      end

      puts "画像データの更新を実施しました。"
    end

    desc "version", "imageshelfのバージョン番号を表示します"
    def version
      puts "imageshelf ver:#{Imageshelf::VERSION}"
    end

  end
end
