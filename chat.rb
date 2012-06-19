require 'core_ext'
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
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
      <!--<script># {OPAL_SOURCE}</script>-->
    </head>
    <body>
      <input type="text" name="nick" id='nick' placeholder='your nickname!'/>
      <dl id='messages'></dl>
      <input type="text" name="message" id='message' placeholder='chat!'/>
      <a href='#' id='send_message'>Send</a>
      
      <script>
        var socket = io.connect('http://localhost:3000');
        socket.on('message', function (data) {
          console.log('message', data)
          $('#messages').append( $('<dd>'+data.text+'</dd>') )
        });
        
        $('#send_message').click(function() {
          var text = $('#message')[0].value
          var nick = $('#nick')[0].value
          socket.emit('message.new', {nick: nick, text: text})
        });
      </script>
      
    </body>
  </html>
  HTML_
end

server.start!


Socket.io server.server do
  emit :message, {text: 'Connected'}
  
  on 'message.new' do |data|
    emit :message, data
  end
end

