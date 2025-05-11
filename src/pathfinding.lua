local Jumper = {}
Jumper.Grid = require("modules.jumper.grid")
Jumper.Pathfinder = require("modules.jumper.pathfinder")

local Tower = require("models.tower")

local WALKABLE = 0

-- Pathfinding module for the game
Pathfinding = {}
Pathfinding.grid = nil
Pathfinding.jumperGrid = nil

local function isWalkable(object)
  return getmetatable(object) ~= Tower
end

---@param grid Grid
local function getJumperMap(grid)
  local jumperMap = {}

  for row = 1, grid.numberOfRows do
    jumperMap[row] = {}
    for column = 1, grid.numberOfColumns do
      local object = grid:getObject(column, row)
      if object and isWalkable(object) then
        jumperMap[row][column] = 1
      else
        jumperMap[row][column] = 0
      end
    end
  end
  return jumperMap
end

local function deepcopy(orig, copies)
  copies = copies or {}
  local orig_type = type(orig)
  local copy
  if orig_type == "table" then
    if copies[orig] then
      copy = copies[orig]
    else
      copy = {}
      copies[orig] = copy
      for orig_key, orig_value in next, orig, nil do
        copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
      end
      setmetatable(copy, deepcopy(getmetatable(orig), copies))
    end
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

function Pathfinding.updateJumperGrid()
  local grid = Pathfinding.grid
  if not grid then
    error("Grid is not set. Please set the grid before calling toJumperGrid.")
  end

  local jumperMap = getJumperMap(grid)
  Pathfinding.jumperGrid = Jumper.Grid(jumperMap)
end

---@param grid Grid
---@param newObject PathElement|Tower
---@param startX number
---@param startY number
---@param endX number
---@param endY number
function Pathfinding.getPathWithGrid(grid, newObject, startX, startY, endX, endY)
  local gridCopy = deepcopy(grid)
  gridCopy.objects[newObject.coordinate] = newObject

  local jumperGrid = Jumper.Grid(getJumperMap(gridCopy))
  local pathfinder = Jumper.Pathfinder(jumperGrid, "ASTAR", WALKABLE)
  pathfinder:setMode("ORTHOGONAL")

  return pathfinder:getPath(startX, startY, endX, endY)
end

function Pathfinding.getPath(startX, startY, endX, endY)
  if not Pathfinding.jumperMap or #Pathfinding.jumperMap == 0 then
    Pathfinding.updateJumperGrid()
  end

  local pathfinder = Jumper.Pathfinder(Pathfinding.jumperGrid, "ASTAR", WALKABLE)
  pathfinder:setMode("ORTHOGONAL")

  local path = pathfinder:getPath(startX, startY, endX, endY)

  return path
end

return Pathfinding
