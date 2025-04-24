-- Coordinate in grid
---@class Coordinate
---@field gridX number
---@field gridY number
local Coordinate = {}
Coordinate.__index = Coordinate

---@param gridX number
---@param gridY number
---@return Coordinate
function Coordinate.new(gridX, gridY)
    local self = setmetatable({}, Coordinate)
    self.gridX = gridX
    self.gridY = gridY
    return self
end

return Coordinate
