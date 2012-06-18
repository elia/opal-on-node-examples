module Kernel
  def p *args
    `return console.log.apply(console, #{args})`
  end
end

OPAL_SOURCE = `Opal.source();`
