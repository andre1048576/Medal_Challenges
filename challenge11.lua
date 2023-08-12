

local lastYPos
-- challenge function returns whether mario has failed the challenge.
---@param m MarioState
local function main_challenge(m)
    if m.action ~= 6436 then
        m.health = m.health - math.max(m.pos.y - lastYPos,0)
    end
    lastYPos = m.pos.y
end


-- called when the challenge is first started
local function init_challenge()
    warp_to_level(LEVEL_WF,1,1)
    lastYPos = 0
end

-- criteria returns true when the challenge has been completed (almost always collecting a star)
---@param m MarioState
local function challenge_criteria(m)
    local obj = m.interactObj
    if (not obj) or not obj.behavior then return end
    if obj_is_medal(obj) then
        return true
    end
end

---@type challenge
local challenge = {
    init = init_challenge,
    challenge = main_challenge,
    criteria = challenge_criteria,
    index = "VN11",
    medal = MEDALS.YELLOW,
    star = 0,
    name = "Chip off whomp's block",
    description = "You've finally made it to Whomp's Fortress, a stage so iconic it reappeared in- has Mario sprained his ankle? Great, he messed up his entry spin. \z
    Any amount of verticality is painful with a sprained ankle. Doesn't matter if it's a jump or a leasurely stroll, try going up as little as possible. \z
    Can you scale the fortress and chip off whomp's block with a sprained ankle?",
    modifiers = {MODIFIERS.GROUNDED}
}

add_challenge(challenge)