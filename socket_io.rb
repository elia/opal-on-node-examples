module Socket
  def self.io port, &block
    new(port).start(&block)
  end
  
  def initialize port_or_server
    @port_or_server = port_or_server
  end
  
  def emit key, data
    data = _hash_to_object(data)
    `#{socket}.emit(key, data)`
  end
  
  def on key, &block
    %x{
      var _this = this;
      #{socket}.on(#{key}, function(){
        block.call(_this)
      });
    }
    
  end
  
  def socket
    @socket ||= `require('socket.io').listen(this.port_or_server)`
  end
  
  def start &block
    on :connection, &block
  end
end
puts 'ciao'