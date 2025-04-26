local Colors = require("ui/colors")
local Coordinate = require("coordinate")
local Tower = require("tower")

---@class Grid
---@field numberOfRows number
---@field numberOfColumns number
---@field towers Tower[]
local Grid = {}
Grid.__index = Grid

function Grid.new(numberOfRows, numberOfColumns)
  local self = setmetatable({}, Grid)
  self.numberOfRows = numberOfRows
  self.numberOfColumns = numberOfColumns

  local towers = {}
  for y = 1, numberOfRows do
    towers[y] = {}
    for x = 1, numberOfColumns do
      towers[y][x] = false
    end
  end

  -- Temporary
  local coordinate = Coordinate.new(3, 5)
  local tower = Tower.new(coordinate, "fire")
  towers[coordinate.gridY][coordinate.gridX] = tower

  self.towers = towers

  print(self.towers[3][5])

  return self
end

-- love methods

function Grid:draw()

  love.graphics.setColor(Colors.gridBackround)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

  local gridHeight = love.graphics.getHeight() - 200

  local gridItemWidth = love.graphics.getWidth() / self.numberOfColumns
  local gridItemHeight = gridHeight / self.numberOfRows

  for row = 1, self.numberOfRows do
    for column = 1, self.numberOfColumns do
      local tower = self.towers[row][column]
      if tower then
        love.graphics.setColor(1, 0, 0)   
      else
        love.graphics.setColor(Colors.gridItem)
      end
      local x = (column - 1) * gridItemWidth
      local y = (row - 1)* gridItemHeight
      love.graphics.rectangle("fill", x, y, gridItemWidth - 2, gridItemHeight - 2)
    end
  end
end

-- class methods

function Grid:addTower(tower)
  table.insert(self.towers, tower)
end

function Grid:removeTower(towerToRemove)
  for tower in self.towers do
    if tower.coordinate == towerToRemove.coordinate then
      table.remove(towerToRemove)
      break
    end
  end
end

return Grid
