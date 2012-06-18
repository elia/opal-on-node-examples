require 'core_ext'

# puts OPAL_SOURCE
require 'socket_io'
require 'buble'

server = Buble.new 3000

server.get(/.*/) do |resp|
  #{require_client('socket_client')}
  <<-HTML_
  <html>
    <head>
      <title>Ahoy!</title>
      <script src="/socket.io/socket.io.js"></script>
      <script>#{OPAL_SOURCE}</script>
      <script>
        var socket = io.connect('http://localhost:3000');
        socket.on('message', function (data) {
          document.getElementById('messages').innerHTML += '<li>'+data.text+'</li>';
        });
        function send_message() {
          var text = document.getElementById('message').value
          socket.emit('message', {text: text})
          console.log()
        }
        
      </script>
    </head>
    <body>
      <dl id='messages'/>
      <form method='post' onsubmit='send_message();return false;'>
        <input type="text" name="message" id='message' placeholder='chat!'/>
      </form>
    </body>
  </html>
  HTML_
end

server.start!

Socket.io server.server do
  # on connection
  
  emit :message, {text: 'hello world'}
  
  on :message do |data|
    `console.log(this)`
    puts data
    emit :message, data
  end
end

