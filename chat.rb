require 'core_ext'
require 'socket_io'
require 'buble'

server = Buble.new 3000

server.get(/^\/opal\/opal.js$/) do |request|
  @headers['Content-Type'] = 'application/javascript'
  return OPAL_SOURCE
end

server.get(/^\/$/) do |request|
  #{require_client('socket_client')}
  File.read('./chat.html')
end

server.start!


Socket.io server.server do
  emit :status, 'Connected!'
  
  on 'message.new' do |data|
    broadcast :message, data
  end
  
  on :connected do |data|
    broadcast :message, text: "#{`data.nick`} connected", nick: '<system>'
  end
end

