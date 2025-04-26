WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

STATES = {
	GAME = "game",
}

local Button = require("ui.components.button")
local Game = require("game")

local game = {}
local state = STATES.GAME

function love.load()
	love.window.setTitle("Tower Defence")

	love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
		resizable = false,
		vsync = true,
		minwidth = 400,
		minheight = 400,
	})

	game = Game.new()
end

function love.update(_)
	if state == STATES.GAME then
		game:update()
	end
end

function love.draw()
	if state == STATES.GAME then
		game:draw()
	end
end

function love.mousepressed(x, y, mbutton)
	if state == STATES.GAME then
		game:mousepressed(x, y, mbutton)
	end
end
