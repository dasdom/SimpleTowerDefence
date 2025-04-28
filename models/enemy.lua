---@class Enemy
---@field name string
---@field health number
---@field armor number
---@field speed number
---@field position table
local Enemy = {}
Enemy.__index = Enemy

-- Constructor
---@param name string
---@param health number
---@param armor number
---@param speed number
---@return Enemy
function Enemy.new(name, health, armor, speed)
  local self = setmetatable({}, Enemy)

  self.name = name
  self.health = health
  self.armor = armor
  self.speed = speed

  return self
end

---@return Enemy -- Returns an enemy of the type `goblin`.
function Enemy.goblin()
  return Enemy.new("Goblin", 10, 10, 1)
end
