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

function Pathfinding.updateJumperGrid()
  local grid = Pathfinding.grid
  if not grid then
    error("Grid is not set. Please set the grid before calling toJumperGrid.")
  end

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

  Pathfinding.jumperGrid = Jumper.Grid(jumperMap)
end

function Pathfinding.getPath(startX, startY, endX, endY)
  print("getPath called")
  if not Pathfinding.jumperMap or #Pathfinding.jumperMap == 0 then
    Pathfinding.updateJumperGrid()
  end

  local pathfinder = Jumper.Pathfinder(Pathfinding.jumperGrid, "ASTAR", WALKABLE)
  pathfinder:setMode("ORTHOGONAL")

  local path = pathfinder:getPath(startX, startY, endX, endY)

  return path
end

return Pathfinding
