-- Coordinate in grid
---@class Coordinate
---@field gridX number Grid X-coordinate
---@field gridY number Grid Y-coordinate
---@field private keyCache string Cached key for the coordinate
local Coordinate = {}
Coordinate.__index = Coordinate

-- Constructor
---@param gridX number Grid X-coordinate
---@param gridY number Grid Y-coordinate
---@return Coordinate -- A new Coordinate instance
function Coordinate.new(gridX, gridY)
  local self = setmetatable({}, Coordinate)
  self.gridX = gridX
  self.gridY = gridY
  self.keyCache = nil
  return self
end

function Coordinate:__eq(other)
  return self.gridX == other.gridX and self.gridY == other.gridY
end

-- Generates a unique key for the coordinate
-- This key is used for storing the coordinate in a table.
--- @return string -- The unique key representing the coordinate
function Coordinate:key()
  if not self.keyCache then
    self.keyCache = string.format("%d,%d", self.gridX, self.gridY)
  end

  return self.keyCache
end

return Coordinate
