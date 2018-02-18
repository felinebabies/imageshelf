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

        # 画像のハッシュを元に、画像の存在するパスを返す
        get '/image/:hash' do |hash|
            filepatharray = Dbaccess::getimagepathbyhash(hash)
            send_file(filepatharray.first["fullpath"])
        end
    end
end
