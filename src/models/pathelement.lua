---@class PathElement
---@field coordinate Coordinate
local PathElement = {}
PathElement.__index = PathElement

---@param coordinate Coordinate
---@return PathElement
function PathElement.new(coordinate)
  local self = setmetatable({}, PathElement)
  self.coordinate = coordinate
  return self
end

return PathElement
