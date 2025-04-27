local Button = {}
Button.__index = Button

local Colors = require("ui.colors")

--- @class Button
--- @field text string
--- @field x number
--- @field y number
--- @field width number
--- @field height number
--- @field action function
--- @field draw function
--- @field contains function
--- @field onClick function
--- @field private font love.Font
--- @return Button
function Button.new(text, x, y, width, height, action)
  local self = setmetatable({}, Button)

  self.text = text
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.action = action
  self.font = love.graphics.newFont(18)

  return self
end

function Button:draw()
  -- Draw button background and text
  love.graphics.setColor(Colors.buttonBackground)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

  love.graphics.setColor(Colors.buttonText)
  love.graphics.printf(self.text, self.font, self.x, self.y + (self.font:getBaseline() / 2), self.width, "center")
end

---@param x number Position on the x-axis
---@param y number Position on the y-axis
function Button:contains(x, y)
  return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
end

function Button:onClick()
  if self.action then
    self.action()
  end
end

return Button
