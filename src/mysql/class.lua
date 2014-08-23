local function class(constructor, parent)
  local class, mt = {}, {}
  class.__index = class
  if constructor then
    function mt:__call(...)
      return setmetatable(constructor(...), self)
    end
  else
    function mt:__call()
      return setmetatable({}, self)
    end
  end
  if parent then
    mt.__index = parent
  end
  return setmetatable(class, mt)
end

do
  local Foo = class()
  function Foo:set(value)
    self.value = value
  end

  local f = Foo(1)
  assert(f.value == nil)
  f:set(2)
  assert(f.value == 2)
end

do
  local Foo = class(function(value)
    return { value = value }
  end)
  function Foo:set(value)
    self.value = value
  end

  local f = Foo(1)
  assert(f.value == 1)
  f:set(2)
  assert(f.value == 2)
end

do
  local Animal = class(function(name)
    return { name = name }
  end)

  local Dog = class(function(name)
    return Animal(name)
  end, Animal)
  function Dog:speak()
    return self.name .. ' says woof'
  end

  local Cat = class(Animal, Animal)
  function Cat:speak()
    return self.name .. ' says meow'
  end

  local dog = Dog('Fido')
  local cat = Cat('Felix')
  assert(dog:speak() == 'Fido says woof')
  assert(cat:speak() == 'Felix says meow')
end

return class
