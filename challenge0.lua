
-- challenge function returns whether mario has failed the challenge.
---@param m MarioState
local function main_challenge(m)
    if m.healCounter > 0 then
        m.hurtCounter = m.hurtCounter + 1
    end
    m.healCounter = 0
end


-- called when the challenge is first started
local function init_challenge()
    warp_to_level(LEVEL_LLL,1,6)
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

local function on_interact(m,o,it)
end

---@type challenge
local challenge = {
    init = init_challenge,
    challenge = main_challenge,
    criteria = challenge_criteria,
    on_interact = on_interact,
    index = "VN0",
    medal = MEDALS.GREEN,
    star = 6,
    name = "Lethal Lava Land 100 coins",
    description = "Lethal Lava Land is a land full of fire and random objects floating above a sea of lava, but you already know that. What you didn't know is that \z
    due to the history of the area, each coin here contains a fragment of a star. If you were able to collect 100 coins, then you'd form a new power star to help defeat Bowser. \z
    However, please remember to be careful as the coins' odd composition prevents them from healing you. Can you collect the 100 star fragments to form a star in Lethal Lava Land?",
    modifiers = {MODIFIERS.NOHEAL}
}

add_challenge(challenge)