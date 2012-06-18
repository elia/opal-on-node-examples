class Buble
  module Sinatra
    def get regexp, &action
      add_route :get, regexp, action
    end
  
    def post regexp, &action
      add_route :post, regexp, action
    end
  
    def add_route method, regexp, action
      routes(method) << [regexp, action]
    end
  
    def process request
      route, action = nil, nil
      method = `request.method`.downcase
      path = `request.url`
      routes(method).each do |route_and_action|
        route = route_and_action.first
        if route =~ path
          action = route_and_action.last
          break
        end
      end
      puts "\nProcessing #{path.inspect} with #{route.inspect}"
      action.call(request)
    end
  
    def routes method
      @routes = @routes || {}
      @routes[method] = @routes[method] || []
    end
  end
  
  include Sinatra
  
  def initialize port
    @http = `require('http')`
    @port = port
  end
  
  def start &block
    @server = %x{
      this.http.createServer(function(req, res) {
        var body = "";
        req.on('data', function (chunk) {
          body += chunk;
        });
        req.on('end', function(){
          req.body = body
          var rackResponse = (block.call(block._s, req, res));
          res.end(rackResponse[2].join(' '));
        });
      })
    }
    
    `this.server.listen(this.port);`
  end
  
  def start!
    puts "Starting Buble server on port #{@port}"
    start do |request|
      [200, {'Content-Type' => 'text/plain'}, [process(request)]]
    end
  end
  
  attr_reader :server
end


