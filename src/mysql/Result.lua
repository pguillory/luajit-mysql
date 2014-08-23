local ffi = require 'ffi'
local class = require 'Class'

--------------------------------------------------------------------------------
-- Result
--------------------------------------------------------------------------------

local Result = class(function(result)
  local num_fields = result:num_fields()
  local names, convert, self = {}, {}, {}

  for i = 1, num_fields do
    local field = result:fetch_field_direct(i - 1)
    names[i] = ffi.string(field.name)
    convert[i] = field:read_func()
  end

  while true do
    local row = result:fetch_row()
    if row == ffi.NULL then
      result:free()
      return self
    end
    local lengths = result:fetch_lengths()
    local values = {}
    for i = 1, num_fields do
      values[i] = names[i]
      if row[i - 1] ~= ffi.NULL then
        local value = ffi.string(row[i - 1], lengths[i - 1])
        values[names[i]] = convert[i](value)
      end
    end
    table.insert(self, values)
  end
end)

function pad_left(s, n, c)
  for i = #s + 1, n do
    s = c .. s
  end
  return s
end

function pad_right(s, n, c)
  for i = #s + 1, n do
    s = s .. c
  end
  return s
end

function value_to_string(value, length)
  if type(value) == 'nil' then
    return 'NULL'
  elseif type(value) == 'number' then
    return pad_left(tostring(value), length, ' ')
  else
    assert(type(value) == 'string')
    return value
  end
end

function Result:__tostring()
  if #self == 0 then
    return 'Empty set'
  end

  local lengths = {}

  for _, row in ipairs(self) do
    for _, name in ipairs(row) do
      if not lengths[name] then
        lengths[name] = #name
      end
      local value = value_to_string(row[name], 0)
      if lengths[name] < #value then
        lengths[name] = #value
      end
    end
  end

  local buffer = {}
  for _, name in ipairs(self[1]) do
    table.insert(buffer, pad_right('+', lengths[name] + 3, '-'))
  end
  table.insert(buffer, '+')
  local divider = table.concat(buffer)

  local buffer = {}
  table.insert(buffer, divider)
  table.insert(buffer, '\n')
  for _, name in ipairs(self[1]) do
    table.insert(buffer, pad_right('| ' .. name, lengths[name] + 3, ' '))
  end
  table.insert(buffer, '|\n')
  table.insert(buffer, divider)
  table.insert(buffer, '\n')
  for _, row in ipairs(self) do
    for _, name in ipairs(row) do
      local value = value_to_string(row[name], lengths[name])
      table.insert(buffer, pad_right('| ' .. value, lengths[name] + 3, ' '))
    end
    table.insert(buffer, '|\n')
  end
  table.insert(buffer, divider)
  return table.concat(buffer)
end

return Result
