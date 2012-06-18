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
      console.log(_this);
      #{socket}.on(#{key}, function(){
        block.apply(_this)
      });
    }
    
  end
  
  def socket
    @socket ||= `require('socket.io').listen(this.port_or_server)`
  end
  
  def start &block
    on :connection, &block
  end
  
  def _hash_to_object hash
    object = `{}`
    hash.each_pair do |k,v|
      `object[#{k.to_s}] = #{v};`
    end
    return object
  end
end
