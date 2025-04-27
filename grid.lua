local Colors = require("ui.colors")
local Coordinate = require("coordinate")
local Tower = require("tower")

---@class Grid
---@field width number
---@field height number
---@field numberOfRows number
---@field numberOfColumns number
---@field towers table<Coordinate, Tower>
local Grid = {}
Grid.__index = Grid

function Grid.new(width, height, numberOfRows, numberOfColumns)
  local self = setmetatable({}, Grid)
  self.width = width
  self.height = height
  self.numberOfRows = numberOfRows
  self.numberOfColumns = numberOfColumns

  self.towers = {}
  return self
end

-- love methods

function Grid:draw()
  local gridItemWidth = self.width / self.numberOfColumns
  local gridItemHeight = self.height / self.numberOfRows

  for row = 1, self.numberOfRows do
    for column = 1, self.numberOfColumns do
      local tower = self:getTower(column, row)
      if tower then
        love.graphics.setColor(1, 0, 0)
      else
        love.graphics.setColor(Colors.gridItem)
      end
      local x = (column - 1) * gridItemWidth
      local y = (row - 1) * gridItemHeight
      love.graphics.rectangle("fill", x, y, gridItemWidth - 2, gridItemHeight - 2)
    end
  end
end

-- class methods

function Grid:addTowerAt(x, y)
  local coordinate = self:coordinateFor(x, y)
  local tower = Tower.new(coordinate, "fire")
  self:addTower(tower)
end

function Grid:addTower(tower)
  self.towers[tower.coordinate:key()] = tower
end

---@param column number
---@param row number
function Grid:getTower(column, row)
  local coordinate = Coordinate.new(column, row)
  return self.towers[coordinate:key()]
end

function Grid:removeTower(towerToRemove)
  for tower in self.towers do
    if tower.coordinate == towerToRemove.coordinate then
      table.remove(towerToRemove)
      break
    end
  end
end

function Grid:coordinateFor(x, y)
  local gridItemWidth = self.width / self.numberOfColumns
  local gridItemHeight = self.height / self.numberOfRows

  local column = math.floor(x / gridItemWidth + 1)
  local row = math.floor(y / gridItemHeight + 1)
  return Coordinate.new(column, row)
end

return Grid
