local Color = require("ui.colors")
local Button = require("ui.components.button")

---@class MainMenu
---@field buttons Button[]
local MainMenu = {}
MainMenu.__index = MainMenu

function MainMenu.new(startGameAction)
  local self = setmetatable({}, MainMenu)
  self.buttons = {}

  local centerX = love.graphics.getWidth() / 2
  local centerY = love.graphics.getHeight() / 2

  ---@type Button
  local startGameButton = Button.new("Start Game", centerX - 90, centerY + 20, 180, 40, startGameAction)
  table.insert(self.buttons, startGameButton)

  return self
end

function MainMenu:draw()
  -- draw background
  love.graphics.setColor(Color.mainMenuBackground)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

  -- draw title
  love.graphics.setColor(Color.mainMenuFontColor)
  love.graphics.setFont(love.graphics.newFont(32))
  love.graphics.printf("Tower Defense", 0, 50, love.graphics.getWidth(), "center")

  -- draw buttons
  for _, button in ipairs(self.buttons) do
    button:draw()
  end
end

function MainMenu:update()
  -- Update menu logic here
end

function MainMenu:mousepressed(x, y, mbutton)
  if mbutton ~= 1 then
    return
  end

  for _, button in ipairs(self.buttons) do
    if button:contains(x, y) then
      button:onClick()
    end
  end
end

return MainMenu
