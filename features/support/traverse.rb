module Traverse
  def traverse(obj,&block)
    case obj
    when Hash
      obj.any? {|k,v| traverse(k,&block) || traverse(v,&block) }
    when Array
      obj.any? {|el| traverse(el,&block) }
    else
      block.call(obj)
    end
  end
end

World(Traverse)
