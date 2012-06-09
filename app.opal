class Server
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
end
# 
# http = require('http')
# var port = process.env.port || 1337;
# http.createServer(function(req, res) {
#   res.writeHead(200, { 'Content-Type': 'text/plain' });
#   res.end('Hello World\n');
# }).listen(port);


server = Server.new 3000
server.start do
  [200, {'Content-Type' => 'text/plain'}, ["Hello World!\n"]]
end



