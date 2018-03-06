require 'imageshelf'
require 'fileutils'
require 'rmagick'


module Imageshelf
    module Thumbnail
        module_function

        THUMB_EXT = ".png"

        def getthumbdir
            rootdir = LocalSettings::get_root_dir
            thumbdir = File.join(rootdir, LOCAL_DATA_DIR_NAME, THUMB_DIR_NAME)
            thumbdir
        end

        def getthumbfilepath(hash)
            thumbdir = getthumbdir

            FileUtils.mkdir_p(thumbdir) unless FileTest.exist?(thumbdir)

            thumbname = File.join(thumbdir, hash + THUMB_EXT)

            thumbname
        end

        # サムネイル画像の生成
        def createthumbnailbyhash(hash)
            filepatharray = Dbaccess::getimagepathbyhash(hash)
            filepatharray.select! do |item|
                File.exist?(item["fullpath"])
            end
            img = Magick::Image.read(filepatharray.first["fullpath"]).first
            img = img.resize_to_fit!(100, 100)
            bg = Magick::Image.new(100, 100) do self.background_color = 'white' end
            bg.composite!(img, Magick::CenterGravity, Magick::OverCompositeOp)

            filename = img.filename
            ext = File.extname(filename)

            thumbname = getthumbfilepath(hash)

            img.write(thumbname)

            thumbname
        end

        # サムネイルを生成してパスを返す
        def getthumbnailpath(hash)
            # サムネイルが存在する場合はそのままパスを返す
            thumbpath = getthumbfilepath(hash)
            if File.exist?(thumbpath) then
                return thumbpath
            end

            #サムネイルが存在しない場合はサムネイルを生成する
            filepatharray = Dbaccess::getimagepathbyhash(hash)
            filepatharray.select! do |item|
                File.exist?(item["fullpath"])
            end
            if filepatharray.empty? then
                # 対象ファイルなしの為エラー
                raise "対象ファイル[#{hash}]が存在しません"
            else
                # サムネイル画像の生成
                thumbpath =  createthumbnailbyhash(hash)
            end

            thumbpath
        end

    end

end