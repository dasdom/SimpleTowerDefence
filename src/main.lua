-- Constants
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

-- States
STATES = {
  GAME = {},
  MENU = {},
}

-- Modules
local Game = require("src.game")
local MainMenu = require("src.main_menu")

-- Local Properties
local game = {}
local menu = {}
local state = STATES.MENU

local startGameAction = function()
  state = STATES.GAME
end

function love.load()
  love.window.setTitle("Tower Defence")

  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    resizable = false,
    vsync = true,
    minwidth = 400,
    minheight = 400,
  })

  game = Game.new()
  menu = MainMenu.new(startGameAction)
end

function love.update(_)
  if state == STATES.MENU then
    menu:update()
  elseif state == STATES.GAME then
    game:update()
  end
end

function love.draw()
  if state == STATES.MENU then
    menu:draw()
  elseif state == STATES.GAME then
    game:draw()
  end
end

function love.mousepressed(x, y, mbutton)
  if state == STATES.MENU then
    menu:mousepressed(x, y, mbutton)
  elseif state == STATES.GAME then
    game:mousepressed(x, y, mbutton)
  end
end
