require 'thor'

module Imageshelf
  class Command < Thor
    desc "init", "カレントディレクトリをImageshelfの管理対象に設定します"
    def init
      # 既に初期化されていれば、メッセージを表示して終了
      if LocalSettings::already_init? then
        puts "This directory is already initialized."
        exit
      end

      # 初期化用ディレクトリを作成する
      FileUtils.mkdir(LOCAL_DATA_DIR_NAME)

      # 初期化用DBファイルを作成する

      # DBにテーブルを作成する

      # DBに初期設定を描き込む

    end

    desc "update", "初期化済ディレクトリ以下の画像をスキャンして、データベースを更新します"
    def update
      # 初期化されていなければ、メッセージを表示して終了
      unless LocalSettings::already_init? then
        puts "このディレクトリはImageshelfのために初期化されていません。"
        exit
      end

    end

    desc "version", "imageshelfのバージョン番号を表示します"
    def version
      puts "imageshelf ver:#{Imageshelf::VERSION}"
    end

  end
end
