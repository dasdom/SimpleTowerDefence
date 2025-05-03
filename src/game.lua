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
  self.grid = Grid.new(width, height - 200, 10, 20)
  self.buttons = {}
  local button = Button.new("Pathfinding", (width / 2) - 50, (height - 100), 100, 50, function()
    self:calculatePath()
  end)

  table.insert(self.buttons, button)

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

  self.grid:addTowerAt(x, y)

  for _, button in ipairs(self.buttons) do
    if button:contains(x, y) then
      button:onClick()
    end
  end
end

function Game:calculatePath()
  self.grid:getPath()
end

return Game
