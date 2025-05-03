---@class Position
---A class representing a position in a 2D space.
---@field x number The x-coordinate of the position.
---@field y number The y-coordinate of the position.
local Position = {}
Position.__index = Position

---Constructor
---@param x number The x-coordinate of the position.
---@param y number The y-coordinate of the position.
---@return Position A new Position object.
function Position.new(x, y)
  local self = setmetatable({}, Position)

  self.x = x
  self.y = y

  return self
end
