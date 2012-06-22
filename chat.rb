require 'core_ext'
require 'socket_io'
require 'buble'

server = Buble.new 3000

server.get(/^\/$/) do |request|
  #{require_client('socket_client')}
  File.read('./chat.html')
end

server.start!


Socket.io server.server do
  emit :status, 'Connected!'
  
  on 'message.new' do |data|
    emit :message, data
  end
end

