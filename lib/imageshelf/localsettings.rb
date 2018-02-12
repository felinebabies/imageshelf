module Imageshelf
  module LocalSettings
    module_function

    HOST_OS = RbConfig::CONFIG["host_os"]

    # 対応画像拡張子
    IMAGE_EXTS = ["jpg", "jpeg", "png", "gif"]

    # sqlite3 DBファイル名
    SQLITE3DBFILE = 'shelfdata.db'

    def already_init?
      !!get_root_dir
    end

    def os_windows?
      @@os_is_windows ||= HOST_OS =~ /mswin(?!ce)|mingw|bccwin/i
    end

    # 初期化済みのlocalsettingディレクトリを探し、パスを返す
    def get_root_dir
      root_dir = nil
      path = Dir.pwd
      drive_letter = ""
      if os_windows?
        path.encode!(Encoding::UTF_8)
        path.gsub!(/^[a-z]:/i, "")
        drive_letter = $&
      end

      while path != ""
        if File.directory?("#{drive_letter}#{path}/#{LOCAL_DATA_DIR_NAME}")
          root_dir = drive_letter + path
          break
        end
        path.gsub!(%r!/[^/]*$!, "")
      end
      root_dir
    end
  end
end
