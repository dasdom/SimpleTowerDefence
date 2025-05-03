---@class Path
---@field coordinate Coordinate
local Path = {}
Path.__index = Path

---@param coordinate Coordinate
---@return Path
function Path.new(coordinate)
  local self = setmetatable({}, Path)
  self.coordinate = coordinate
  return self
end

return Path
