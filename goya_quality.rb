require 'cgi'
cgi = CGI.new

cgi.out("type" => "text/html", "charset" => "UTF-8") {
  get = cgi['goya_quality']

  "<html>
    <body>
      <p>品質が悪いもののゴーヤの情報は下記になります</p>
      文字列：#{get}
    </body>
  </html>"
}
