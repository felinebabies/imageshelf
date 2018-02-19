require 'imageshelf'
require 'sinatra/base'
require 'haml'

module Imageshelf
    class AppServer < Sinatra::Base
        configure do
            lib_root = File.dirname(__FILE__)
            set :views, File.join(lib_root + '/web/views')
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
    end
end
