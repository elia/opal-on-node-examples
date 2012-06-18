module Kernel
  def p *args
    `return console.log.apply(console, #{args})`
  end
  
  def client_require file
    ``
  end
  
end

OPAL_SOURCE = `Opal.source();`

