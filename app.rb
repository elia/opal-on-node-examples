require 'core_ext'
require 'buble'

server = Buble.new 3000

server.get(/ciao/) do |response|
  <<-HTML
  <html>
    <head>
      <title>Ahoy!</title>
    </head>
    <body>
      <h1>Ciao!</h1>
      <form action='/salute' method='post'>
        <input type="text" name="name" placeholder='your name!'/>
      </form>
    </body>
  </html>
  HTML
end

server.post(/salute/) do |response|
  p response
  "Hi #{`response.body`}"
end

server.get(/.*/) do |response|
  'Hi'
end

server.start!
