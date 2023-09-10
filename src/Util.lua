function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

--[[
    Utility function for slicing tables, a la Python.

    https://stackoverflow.com/questions/24821045/does-lua-have-something-like-pythons-slice
]]
function table.slice(tbl, first, last, step)
    local sliced = {}
  
    for i = first or 1, last or #tbl, step or 1 do
      sliced[#sliced+1] = tbl[i]
    end
  
    return sliced
end

--these are quads function for Basic UI and states
function GenerateQuadsBird(atlas)
    return table.slice(GenerateQuads(atlas, 48, 32), 1, 4)
end

function GenerateQuadsBackground(atlas)
    return GenerateQuads(atlas, 1157, 288)
end

function GenerateQuadsArrows(atlas)
    return GenerateQuads(atlas, 72, 72)
end

-- --these are quads function for UI
-- function GenerateQuadsCoin(atlas)
--     return GenerateQuads(atlas, )
-- end

function GenerateQuadsHearts(atlas)
    return GenerateQuads(atlas, 24, 24)
end

-- these are quads function for Orbs

function GenerateQuadsElementalOrbs(atlas)
    return table.slice(GenerateQuads(atlas, 16, 16), 46, 45 + Orbs)
end


-- these are quads function for Obstacles

function GenerateQuadsPipes(atlas)
    return GenerateQuads(atlas, 70, 288)
end

