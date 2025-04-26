local Button = {}
Button.__index = Button

local Colors = require("ui/colors")

--- @class Button
--- @field text string
--- @field x number
--- @field y number
--- @field width number
--- @field height number
--- @field action function
--- @return Button
function Button.new(text, x, y, width, height, action)
	local self = setmetatable({}, Button)

	self.text = text
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.action = action

	return self
end

function Button:draw()
	love.graphics.setColor(Colors.buttonBackground)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.setColor(Colors.buttonText)
	love.graphics.printf(self.text, self.x, self.y + (self.height / 2) - 10, self.width, "center")
end

function Button:onClick()
	if self.action then
		self.action()
	end
end

return Button
