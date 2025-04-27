local Grid = require("grid")
local Colors = require("ui.colors")

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

  return self
end

function Game:update()
  -- Update game logic here
end

function Game:draw()
  love.graphics.setColor(Colors.gridBackround)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

  self.grid:draw()
end

function Game:mousepressed(x, y, mbutton)
  if mbutton ~= 1 then
    return
  end

  self.grid:addTowerAt(x, y)
end

return Game
