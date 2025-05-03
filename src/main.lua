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
  -- -- Usage Example
  -- -- First, set a collision map
  -- local map = {
  --   { 0, 1, 0, 1, 0 },
  --   { 0, 1, 0, 1, 0 },
  --   { 0, 1, 1, 1, 0 },
  --   { 0, 0, 0, 0, 0 },
  -- }
  -- -- Value for walkable tiles
  -- local walkable = 0
  --
  -- -- Library setup
  -- local Grid = require("modules.jumper.grid") -- The grid class
  -- local Pathfinder = require("modules.jumper.pathfinder") -- The pathfinder class
  --
  -- -- Creates a grid object
  -- local grid = Grid(map)
  -- -- Creates a pathfinder object using Jump Point Search
  -- local myFinder = Pathfinder(grid, "JPS", walkable)
  --
  -- -- Define start and goal locations coordinates
  -- local startx, starty = 1, 1
  -- local endx, endy = 5, 1
  --
  -- -- Calculates the path, and its length
  -- local path = myFinder:getPath(startx, starty, endx, endy)
  -- if path then
  --   print(("Path found! Length: %.2f"):format(path:getLength()))
  --   for node, count in path:nodes() do
  --     print(("Step: %d - x: %d - y: %d"):format(count, node:getX(), node:getY()))
  --   end
  -- end

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
