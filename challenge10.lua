
-- challenge function returns whether mario has failed the challenge.
---@param m MarioState
local function main_challenge(m)
    if m.health < 0x880 then
        return true
    end
    return challenge_timer >= 2700
end


-- called when the challenge is first started
local function init_challenge()
    warp_to_level(LEVEL_BITFS,1,1)
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
    index = "VN10",
    medal = MEDALS.RED,
    star = 0,
    speedrun_frame_limit = 2700,
    name = "Red coins in the fire sea",
    description = "You've managed to corner Bowser after finding his sub! He's currently located in the fire sea, and is using a nearby power star to fuel his escape! \z
    You've got 90 seconds to collect the star before he charges up fully and gets away! Make sure not to sustain any injuries on the way, as the \z
    fire sea does not treat the injured well. Can you open Bowser's lair before he retreats while dealing with the fiery tribulations?",
    modifiers = {MODIFIERS.SPEEDRUN,MODIFIERS.DAREDEVIL}
}

add_challenge(challenge)