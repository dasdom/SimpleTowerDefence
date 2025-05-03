local Colors = require("src.ui.colors")
local Coordinate = require("src.models.coordinate")
local Tower = require("src.models.tower")
local Path = require("src.models.path")

local Jumper = {}
Jumper.Grid = require("modules.jumper.grid")
Jumper.Pathfinder = require("modules.jumper.pathfinder")

local function isTower(object)
  return getmetatable(object) == Tower
end

local function isPath(object)
  return getmetatable(object) == Path
end

---@class Grid
---@field width number
---@field height number
---@field numberOfRows number
---@field numberOfColumns number
---@field objects table<Coordinate, Path|Tower>
local Grid = {}
Grid.__index = Grid

function Grid.new(width, height, numberOfRows, numberOfColumns)
  local self = setmetatable({}, Grid)
  self.width = width
  self.height = height
  self.numberOfRows = numberOfRows
  self.numberOfColumns = numberOfColumns

  self.objects = {}
  return self
end

-- love methods

function Grid:draw()
  local gridItemWidth = self.width / self.numberOfColumns
  local gridItemHeight = self.height / self.numberOfRows

  for row = 1, self.numberOfRows do
    for column = 1, self.numberOfColumns do
      local object = self:getObject(column, row)

      if object and isTower(object) then
        love.graphics.setColor(1, 0, 0)
      elseif object and isPath(object) then
        love.graphics.setColor(0, 1, 0)
      else
        love.graphics.setColor(Colors.gridItem)
      end

      local x = (column - 1) * gridItemWidth
      local y = (row - 1) * gridItemHeight
      love.graphics.rectangle("fill", x, y, gridItemWidth - 2, gridItemHeight - 2)
    end
  end
end

-- TOWER METHODS --

---@param x number
---@param y number
---@param towerType TowerType
function Grid:addTowerAt(x, y, towerType)
  local coordinate = self:coordinateFor(x, y)
  local tower = {}

  if towerType == "fire" then
    tower = Tower.newFireTower(coordinate)
  elseif towerType == "rocket" then
    tower = Tower.newRocketTower(coordinate)
  elseif towerType == "laser" then
    tower = Tower.newLaserTower(coordinate)
  else
    error("Invalid tower type: " .. tostring(towerType))
  end

  self:addObject(tower)
end

---@param object Tower|Path
function Grid:addObject(object)
  self.objects[object.coordinate:key()] = object
end

---@param column number
---@param row number
---@return Tower|Path
function Grid:getObject(column, row)
  local coordinate = Coordinate.new(column, row)
  return self.objects[coordinate:key()]
end

---@param objectToRemove Tower|Path
function Grid:remove(objectToRemove)
  for tower in self.objects do
    if tower.coordinate == objectToRemove.coordinate then
      table.remove(objectToRemove)
      break
    end
  end
end

-- PATH METHODS --

---@param x number
---@param y number
function Grid:addPath(x, y)
  local coordinate = self:coordinateFor(x, y)
  local path = Path.new(coordinate)

  self:addObject(path)
end

function Grid:reset()
  for _, object in pairs(self.objects) do
    self.objects[object.coordinate:key()] = nil
  end
end

function Grid:coordinateFor(x, y)
  local gridItemWidth = self.width / self.numberOfColumns
  local gridItemHeight = self.height / self.numberOfRows

  local column = math.floor(x / gridItemWidth + 1)
  local row = math.floor(y / gridItemHeight + 1)
  return Coordinate.new(column, row)
end

function Grid:asJumperGrid()
  local map = {}

  for row = 1, self.numberOfRows do
    map[row] = {}
    for column = 1, self.numberOfColumns do
      local object = self:getObject(column, row)
      if object and isTower(object) then
        map[row][column] = 1 -- Not walkable
      else
        map[row][column] = 0 -- Walkable
      end
    end
  end

  return map
end

---@param startX number
---@param startY number
---@param endX number
---@param endY number
function Grid:getPath(startX, startY, endX, endY)
  local jumperGrid = self:asJumperGrid()
  local grid = Jumper.Grid(jumperGrid)
  local walkable = 0
  local pathfinder = Jumper.Pathfinder(grid, "ASTAR", walkable)

  local path = pathfinder:getPath(startX, startY, endX, endY)

  if path then
    for node, _ in path:nodes() do
      local x = node:getX()
      local y = node:getY()
      local coordinate = Coordinate.new(x, y)
      local pathObject = Path.new(coordinate)
      self:addObject(pathObject)
    end
  end
end

return Grid
