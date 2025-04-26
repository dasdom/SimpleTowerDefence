local Grid = require("grid")

---@class Game
---@field grid Grid
---@field buttons Button[]
local Game = {}
Game.__index = Game

function Game.new()
	local self = setmetatable({}, Game)
	self.grid = Grid.new(10, 20)
	self.buttons = {}

	return self
end

function Game:update()
	-- Update game logic here
end

function Game:draw()
	self.grid:draw()
end

function Game:mousepressed(x, y, mbutton) 
  self.grid:addTowerAt(x, y)
end

return Game
