require 'core_ext'

# puts OPAL_SOURCE
require 'socket_io'
require 'buble'

server = Buble.new 3000

Socket.io `#{server}.server` do
  # on connection
  
  emit :news, {hello: 'world'}
  
  on :other_event do |data|
    puts data
  end
end

server.get /chat/ do
  <<-HTML
  <html>
    <head>
      <title>Ahoy!</title>
    </head>
    <body>
      <dl id='messages'/>
      <form action='/salute' method='post'>
        <input type="text" name="message" placeholder='chat!'/>
      </form>
    </body>
  </html>
  HTML
end