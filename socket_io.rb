require 'hash_to_object'

module Socket
  def self.io port_or_server, &block
    new(port_or_server).start(&block)
  end
  
  def initialize port_or_server
    @port_or_server = port_or_server
    @io = `require('socket.io').listen(this.port_or_server)`
  end
  
  def emit key, data
    data = data.to_object if `data._klass == #{Hash}`
    `this.socket.emit(key, data)`
  end
  
  def broadcast key, data
    data = data.to_object if `data._klass == #{Hash}`
    `this.socket.emit(key, data)`
    `this.socket.broadcast.emit(key, data)`
  end
  
  def on key, &block
    %x{
      var _this = this;
      #{@socket}.on(#{key}, function(data){
        block.apply(_this, [data])
      });
    }
  end
  
  attr_reader :socket, :io
  
  def start &block
    @socket = nil
    %x{
      block._s = this;
      var _this = this;
      
      this.io.sockets.on('connection', function(socket){
        _this.socket = socket;
        #{block.call}
      });
    }
  end
  
end
