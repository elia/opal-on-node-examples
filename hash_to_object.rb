class Hash
  def to_object
    %x{
      var object,k;
      object = {};
      for (k in this.map) {
        object[k] = this.map[k][1];
      }
      return object;
    }
  end
end

if `require('path').resolve(process.argv[2]) === __filename`
  hash = {a: 1, b: 2}
  object = `{a: 1, b: 2}`
  `console.log(#{hash.to_object}, object)`
  puts `#{hash.to_object}.toString() === object.toString()`
end
