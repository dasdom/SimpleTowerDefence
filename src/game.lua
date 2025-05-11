local Button = require("ui.components.button")
local Coordinate = require("src.models.coordinate")
local Colors = require("ui.colors")
local Enemy = require("models.enemy")
local Grid = require("grid")
local PathFinding = require("src.pathfinding")
local PathElement = require("src.models.pathelement")

---@class Game
---@field grid Grid
---@field enemies Enemy[]
---@field buttons Button[]
local Game = {}
Game.__index = Game

function Game.new()
  local self = setmetatable({}, Game)
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  local centerX = width / 2
  self.grid = Grid.new(width, height - 200, 10, 20, 1, 1, 20, 10)
  self.buttons = {}
  local pathfindingButton = Button.new("Pathfinding", centerX, (height - 30), 180, 40, function()
    self:calculatePath()
  end)
  table.insert(self.buttons, pathfindingButton)

  local resetButton = Button.new("Reset", centerX, (height - 90), 180, 40, function()
    self:resetTowers()
  end)
  table.insert(self.buttons, resetButton)

  local spawnEnemyButton = Button.new("Spawn Enemy", centerX, (height - 150), 180, 40, function()
    self:spawnEnemy()
  end)
  table.insert(self.buttons, spawnEnemyButton)

  self.enemies = {}

  return self
end

function Game:update(dt)
  local enemiesToRemove = {}

  for idx, enemy in ipairs(self.enemies) do
    if #enemy.pathElements == 0 then
      error("No path on enemy")
    end

    if not enemy.currentPathIndex then
      enemy.currentPathIndex = 1
    end

    if enemy.shouldUpdatePath then
      local currentCoordinate = self.grid:coordinateFor(enemy.positionX, enemy.positionY)
      if not currentCoordinate then
        error("No coordinate found for enemy position")
      end
      local path = PathFinding.getPath(currentCoordinate.gridX, currentCoordinate.gridY, self.grid.endX, self.grid.endY)
      if path then
        local pathElements = {}
        for node, _ in path:nodes() do
          local coord = Coordinate.new(node:getX(), node:getY())
          local pathElement = PathElement.new(coord)
          table.insert(pathElements, pathElement)
        end
        enemy.pathElements = pathElements
      end
      enemy.currentPathIndex = 1
      enemy.shouldUpdatePath = false
    end

    local currentPathElement = enemy.pathElements[enemy.currentPathIndex].coordinate
    local nextPathElement = enemy.pathElements[enemy.currentPathIndex + 1].coordinate

    if not nextPathElement then
      table.insert(enemiesToRemove, idx)
    end
    local nextCenterX, nextCenterY = self.grid:getCenterForCoordinateAt(nextPathElement.gridX, nextPathElement.gridY)

    if enemy.positionX < nextCenterX then
      enemy.positionX = enemy.positionX + 0.1
    elseif enemy.positionX > nextCenterX then
      enemy.positionX = enemy.positionX - 0.1
    end

    if enemy.positionY < nextCenterY then
      enemy.positionY = enemy.positionY + 0.1
    elseif enemy.positionY > nextCenterY then
      enemy.positionY = enemy.positionY - 0.1
    end

    local newCurrentCoordinate = self.grid:coordinateFor(enemy.positionX, enemy.positionY)
    if not newCurrentCoordinate then
      error("No coordinate found for enemy position")
    end
    if currentPathElement:key() ~= newCurrentCoordinate:key() then
      if #enemy.pathElements > (enemy.currentPathIndex + 1) then
        enemy.currentPathIndex = enemy.currentPathIndex + 1
      else
        print("enemy reached end")
        table.insert(enemiesToRemove, idx)
      end
    end
  end

  for i = #enemiesToRemove, 1, -1 do
    table.remove(self.enemies, enemiesToRemove[i])
  end
end

function Game:draw()
  love.graphics.setColor(Colors.gridBackround)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

  self.grid:draw()

  for _, enemy in ipairs(self.enemies) do
    enemy:draw()
  end

  for _, button in ipairs(self.buttons) do
    button:draw()
  end
end

function Game:mousepressed(x, y, mbutton)
  if mbutton ~= 1 then
    return
  end

  local coordinate = self.grid:coordinateFor(x, y)
  if coordinate then
    local gridX, gridY = coordinate.gridX, coordinate.gridY
    self.grid:addTowerAt(gridX, gridY, "fire", self.enemies)
  end

  for _, button in ipairs(self.buttons) do
    if button:contains(x, y) then
      button:onClick()
    end
  end
end

function Game:calculatePath()
  self.grid:getPath(true)
end

function Game:resetTowers()
  self.grid:reset()
end

function Game:spawnEnemy()
  local x, y = self.grid:getCenterForCoordinateAt(self.grid.startX, self.grid.startY)
  local enemy = Enemy.goblin()
  enemy.positionX = x
  enemy.positionY = y

  local path = PathFinding.getPath(self.grid.startX, self.grid.startY, self.grid.endX, self.grid.endY)

  if path then
    local pathElements = {}

    for node, _ in path:nodes() do
      local coord = Coordinate.new(node:getX(), node:getY())
      local pathElement = PathElement.new(coord)
      table.insert(pathElements, pathElement)
    end

    enemy.pathElements = pathElements
  end

  table.insert(self.enemies, enemy)
end

return Game
