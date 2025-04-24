local Coordinate = require("coordinate")

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

function Tower.new(name, coordinate, towerType)
    local self = setmetatable({}, Tower)
    self.name = name
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

return Tower
