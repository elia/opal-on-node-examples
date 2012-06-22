module Kernel
  def p *args
    `return console.log.apply(console, #{args})`
  end
  
  def client_require file
    ``
  end
  
end

class File
  def self.read file
    `return require('fs').readFileSync(#{file}, 'utf8').toString()`
  end
end


OPAL_SOURCE = `Opal.source();`

