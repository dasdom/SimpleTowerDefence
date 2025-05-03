---@alias TowerType
---| "fire"
---| "laser"
---| "rocket"

---@alias UpgradeStatus
---| "0"
---| "1"
---| "2"

---@class Tower
---@field name string
---@field coordinate Coordinate
---@field towerType TowerType
---@field prices table
---@field upgradeStatus UpgradeStatus
---@field damage number
---@field fireFrequency number
local Tower = {}
Tower.__index = Tower

---@param coordinate Coordinate
---@param towerType TowerType
---@return Tower
function Tower.new(coordinate, towerType)
  local self = setmetatable({}, Tower)
  self.coordinate = coordinate
  self.towerType = towerType
  self.upgradeStatus = "0"
  return self
end

function Tower:upgrade()
  if self.upgrade == "0" then
    self.upgrade = "1"
  else
    self.upgrade = "2"
  end
end

-- Constructors for different towers
function Tower.newFireTower(coordinate)
  local tower = Tower.new(coordinate, "fire")
  return tower
end

function Tower.newRocketTower(coordinate)
  local tower = Tower.new(coordinate, "fire")
  return tower
end

function Tower.newLaserTower(coordinate)
  local tower = Tower.new(coordinate, "laser")
  return tower
end

return Tower
