require 'imageshelf'
require 'sinatra/base'
require 'haml'

module Imageshelf
    class AppServer < Sinatra::Base
        configure do
            lib_root = File.dirname(__FILE__)
            set :views, File.join(lib_root + '/web/views')
            set :public_folder, File.join(lib_root + '/web/public')
        end

        get '/' do
            @imagelistarr = Dbaccess::getimagelist

            haml :index
        end

        # 画像のハッシュを元に、画像を返す
        get '/image/:hash' do |hash|
            filepatharray = Dbaccess::getimagepathbyhash(hash)
            filepatharray.select! do |item|
                File.exist?(item["fullpath"])
            end
            if filepatharray.empty? then
                lib_root = File.dirname(__FILE__)
                return send_file(File.join(lib_root + '/web/image/no_image.png'))
            else
                return send_file(filepatharray.first["fullpath"])
            end
        end

        # 画像のサムネイルを返す
        get '/thumb/:hash' do |hash|
            begin
                thumbpath = Thumbnail::getthumbnailpath(hash)
            rescue => e
                puts '画像が見つかりませんでした'
                lib_root = File.dirname(__FILE__)
                thumbpath = File.join(lib_root + '/web/image/no_image.png')
            end
            return send_file(thumbpath)
        end
    end
end
