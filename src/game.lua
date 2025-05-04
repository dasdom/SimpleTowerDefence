local Grid = require("grid")
local Colors = require("ui.colors")
local Button = require("ui.components.button")

---@class Game
---@field grid Grid
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
  local pathfindingButton = Button.new("Pathfinding", centerX, (height - 100), 180, 40, function()
    self:calculatePath()
  end)
  table.insert(self.buttons, pathfindingButton)

  local resetButton = Button.new("Reset", centerX, (height - 150), 180, 40, function()
    self:resetTowers()
  end)
  table.insert(self.buttons, resetButton)

  return self
end

function Game:update()
  -- Update game logic here
end

function Game:draw()
  love.graphics.setColor(Colors.gridBackround)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

  self.grid:draw()

  for _, button in ipairs(self.buttons) do
    button:draw()
  end
end

function Game:mousepressed(x, y, mbutton)
  if mbutton ~= 1 then
    return
  end

  self.grid:addTowerAt(x, y, "fire")

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

return Game
