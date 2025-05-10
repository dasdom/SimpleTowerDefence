local Colors = require("src.ui.colors")
local Coordinate = require("src.models.coordinate")
local Tower = require("src.models.tower")
local PathElement = require("src.models.pathelement")
local PathFinding = require("src.pathfinding")

local function isTower(object)
  return getmetatable(object) == Tower
end

function isPathElement(object)
  return getmetatable(object) == PathElement
end

---@class Grid
---@field width number
---@field height number
---@field numberOfRows number
---@field numberOfColumns number
---@field startX number
---@field startY number
---@field endX number
---@field endY number
---@field objects table<Coordinate, PathElement|Tower>
---@field path table<Coordinate, PathElement>
local Grid = {}
Grid.__index = Grid

function Grid.new(width, height, numberOfRows, numberOfColumns, startX, startY, endX, endY)
  local self = setmetatable({}, Grid)
  self.width = width
  self.height = height
  self.numberOfRows = numberOfRows
  self.numberOfColumns = numberOfColumns
  self.startX = startX
  self.startY = startY
  self.endX = endX
  self.endY = endY
  self.objects = {}

  PathFinding.grid = self

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
      elseif object and isPathElement(object) then
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
---@param enemies Enemy[]
function Grid:addTowerAt(x, y, towerType, enemies)
  local coordinate = Coordinate.new(x, y)
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
  PathFinding.updateJumperGrid()

  if #enemies == 0 then
    local path = PathFinding.getPath(self.startX, self.startY, self.endX, self.endY)
    if not path then
      self:remove(tower)
    end
  end

  for _, enemy in ipairs(enemies) do
    local enemyCoordinate = self:coordinateFor(enemy.positionX, enemy.positionY)
    if not enemyCoordinate then
      return
    end

    local path = PathFinding.getPath(enemyCoordinate.gridX, enemyCoordinate.gridY, self.endX, self.endY)
    if not path then
      self:remove(tower)
      return
    else
      local pathElements = {}

      for node, _ in path:nodes() do
        local coord = Coordinate.new(node:getX(), node:getY())
        local pathElement = PathElement.new(coord)
        table.insert(pathElements, pathElement)
      end

      enemy.pathElements = pathElements
    end
  end
end

---@param object Tower|PathElement
function Grid:addObject(object)
  self.objects[object.coordinate:key()] = object
end

---@param column number
---@param row number
---@return Tower|PathElement
function Grid:getObject(column, row)
  local coordinate = Coordinate.new(column, row)
  return self.objects[coordinate:key()]
end

---@param objectToRemove Tower|PathElement
function Grid:remove(objectToRemove)
  for _, tower in pairs(self.objects) do
    if tower.coordinate == objectToRemove.coordinate then
      self.objects[tower.coordinate:key()] = nil
      break
    end
  end
end

-- PATH METHODS --

function Grid:reset()
  for _, object in pairs(self.objects) do
    self.objects[object.coordinate:key()] = nil
  end
end

function Grid:coordinateFor(x, y)
  -- Check if the coordinates are within the grid bounds
  if x < 0 or y < 0 or x > self.width or y > self.height then
    return nil
  end

  local gridItemWidth = self.width / self.numberOfColumns
  local gridItemHeight = self.height / self.numberOfRows

  local column = math.floor(x / gridItemWidth + 1)
  local row = math.floor(y / gridItemHeight + 1)
  return Coordinate.new(column, row)
end

function Grid:addPath(path)
  if path then
    for node, _ in path:nodes() do
      local x = node:getX()
      local y = node:getY()
      local coordinate = Coordinate.new(x, y)
      local pathObject = PathElement.new(coordinate)
      self:addObject(pathObject)
    end

    self.path = {}
    for _, object in pairs(self.objects) do
      if isPathElement(object) then
        local coordinate = object.coordinate
        local pathObject = PathElement.new(coordinate)
        table.insert(coordinate, pathObject)
      end
    end
  end
end

---@param x number
---@param y number
---@return number, number
function Grid:getCenterForCoordinateAt(x, y)
  local coordinate = Coordinate.new(x, y)

  local gridItemWidth = self.width / self.numberOfColumns
  local gridItemHeight = self.height / self.numberOfRows

  local newX = (coordinate.gridX - 1) * gridItemWidth + gridItemWidth / 2
  local newY = (coordinate.gridY - 1) * gridItemHeight + gridItemHeight / 2

  return newX, newY
end

return Grid
