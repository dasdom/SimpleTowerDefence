WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

local button = require("ui.components.button")

Button = {}

function love.load()
	love.window.setTitle("Tower Defence")

	love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
		resizable = false,
		vsync = true,
		minwidth = 400,
		minheight = 400,
	})

	Button = button.new("Start Game", 100, 100, 200, 50, function()
		print("Start Game button clicked!")
	end)
end

function love.update(_)
	-- Update game logic here
end

function love.draw()
	-- Draw game elements here
	love.graphics.setColor(0.8, 0.8, 0.8, 1)
	love.graphics.print("Hello, Tower Defence!", 100, 100)

	Button:draw()
end

function love.mousepressed(x, y, mbutton)
	if mbutton ~= 1 then
		return
	end

	if x >= Button.x and x <= Button.x + Button.width and y >= Button.y and y <= Button.y + Button.height then
		Button.action()
	end
end
