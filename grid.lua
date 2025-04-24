---@class Grid
---@field numberOfRows number
---@field numberOfColumns number
---@field gridItemWidth number
---@field gridItemHeight number
---@field towers Tower[]
local Grid = {}
Grid.__index = Grid

function Grid.new(numberOfRows, numberOfColumns, gridItemWidth, gridItemHeight)
    local self = setmetatable({}, Grid)
    self.numberOfRows = numberOfRows
    self.numberOfColumns = numberOfColumns
    self.gridItemWidth = gridItemWidth
    self.gridItemHeight = gridItemHeight
    return self
end

function Grid:width()
    return self.numberOfColumns * gridItemWidth
end

function Grid:height()
    return self.numberOfRows * gridItemHeight
end

function Grid:addTower(tower)
    table.insert(self.towers, tower)
end

function Grid:removeTower(towerToRemove)
    for tower in towers do
        if tower.coordinate == towerToRemove.coordinate then
            table.remove(towerToRemove)
            break
        end
    end
end

return Grid
