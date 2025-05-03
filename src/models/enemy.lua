local Position = require("models.position")

---@class Enemy
---@field name string
---@field health number
---@field armor number
---@field speed number
---@field position Position
local Enemy = {}
Enemy.__index = Enemy

-- Constructor
---@param name string
---@param health number
---@param armor number
---@param speed number
---@param position Position?
---@return Enemy
function Enemy.new(name, health, armor, speed, position)
  local self = setmetatable({}, Enemy)

  self.name = name
  self.health = health
  self.armor = armor
  self.speed = speed
  self.position = position or Position.new(0, 0)

  return self
end

-- Methods

-- Move the enemy in the x and y directions
-- This method updates the enemy's position based on its speed and the provided x and y values.
---@param x number -- The x-axis movement
---@param y number -- The y-axis movement
function Enemy:move(x, y)
  self.position.x = self.position.x + x * self.speed
  self.position.y = self.position.y + y * self.speed
end

function Enemy:draw()
  love.graphics.setColor(1, 0, 0)
  love.graphics.circle("fill", self.position.x, self.position.y, 10)
end

-- Create enemy instances

---@return Enemy -- Returns an enemy of the type `goblin`.
function Enemy.goblin()
  return Enemy.new("Goblin", 10, 10, 1)
end
