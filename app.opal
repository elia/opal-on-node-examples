module Sinatra
  def get regexp, &action
    routes(:get) << [regexp, action]
  end
  
  def process request
    action = nil
    method = `request.method`.downcase
    routes(method).each do |route_and_action|
      route = route_and_action.first
      if route =~ `request.url`
        action = route_and_action.last
        break
      end
    end
    action.call(request)
  end
  
  def routes method
    @routes = @routes || {}
    @routes[method] = @routes[method] || []
  end
end

class Server
  include Sinatra
  def initialize port
    @http = `require('http')`
    @port = port
  end
  
  def start &block
    %x{
      this.http.createServer(function(req, res) {
        var rackResponse = (block.call(block._s, req, res));
        res.end(rackResponse[2].join(' '));
      }).listen(this.port);
    }
  end
  
  def start!
    start do |request|
      [200, {'Content-Type' => 'text/plain'}, [process(request)]]
    end
  end
end


module Kernel
  def p *args
    `return console.log.apply(console, #{args})`
  end
end


server = Server.new 3000

server.get(/ciao/) do |response|
  <<-HTML
  <html>
    <head>
      <title></title>
    </head>
    <body>
      <h1>Ciao!</h1>
      <form action='/salute'>
        <input type="text" name="name" placeholder='your name!'/>
      </form>
    </body>
  </html>
  HTML
end

server.post(/^\/salute$/) do |response|
  p response
  "Hi"
end

server.get(/.*/) do |response|
  'Hi'
end

server.start!
