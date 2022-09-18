#gem install webrickでインストールされたライブラリ「webrick」を呼び出しています。
#こうすることで、このRubyファイル内でWebrickが使えるようになります。
require 'webrick'

#Webrickのインスタンスを作成し、serverという名前のローカル変数に入れます。
server = WEBrick::HTTPServer.new({
  #その際の初期値として3つを設定する必要があります。
  #このWebアプリケーションのドメインの設定（ここに書き込まれた記述が、作成するWebアプリケーションのドメインになる）
  :DocumentRoot => '.',
  #このプログラムを実行（翻訳）できるプログラム（Rubyのこと）本体の居場所を指定する記述。
  :CGIInterpreter => WEBrick::HTTPServlet::CGIHandler::Ruby,
  #このWebアプリケーションの情報の出入り口を表す設定。
  :Port => '3000',
})
['INT', 'TERM'].each {|signal|
  Signal.trap(signal){ server.shutdown }
}

#Webサーバを起動した状態で、（DocumentRootの値）/testというURLを送信すると、
#同じディレクトリ階層にあるtest.html.erbファイルを表示するという機能が付与されます。
server.mount('/test', WEBrick::HTTPServlet::ERBHandler, 'test.html.erb')

#下記を追加することでtest.html.erbファイルの<form action='indicate.cgi'> 〜 </form>の内部にある値を、
#indicate.rbに送信することができるようになります
server.mount('/indicate.cgi', WEBrick::HTTPServlet::CGIHandler, 'indicate.rb')

#goyaDBの情報を出力するためのページを作る準備
#その後、goyaDBの情報を出力するためのgoya.rbファイルを作成
server.mount('/goya.cgi', WEBrick::HTTPServlet::CGIHandler, 'goya.rb')

#課題のページ
server.mount('/', WEBrick::HTTPServlet::ERBHandler, '.html.erb')
server.mount('/goya_quality.cgi', WEBrick::HTTPServlet::CGIHandler, 'goya_quality.rb')

#server.startはその名の通り、Webrickのサーバを起動させる、という意味のコードです。
server.start

#http://localhost:3000/
#URLの末尾に、/testを追加して、再読み込みで自分が作成したHTMLページが表示する
#(Webrickで作成されたWebサーバが、/test というリクエストを受け取って、そこから自分の作成したHTMLページを見つけ、そのページを表示したということになります)