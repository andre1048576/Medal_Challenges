

-- challenge function returns whether mario has failed the challenge.
---@param m MarioState
local function main_challenge(m)
    if m.action & ACT_FLAG_SWIMMING_OR_FLYING ~= 0 then
        execute_mario_action(m.marioObj)
        execute_mario_action(m.marioObj)
    end
end


-- called when the challenge is first started
local function init_challenge()
    warp_to_level(LEVEL_TOTWC,1,1)
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
    index = "VN12",
    medal = MEDALS.RED,
    star = 0,
    name = "Tower of the wing cap red coins",
    description = "You've acquired the required stars to access the tower of the wing cap. The last trip here in your previous playthrough was a midly difficult challenge, but nothing overwhelming. \z
    Since then, it's now the 21st century, and the wing cap has been upgraded to the jet cap! This upgrade allows for crazy distances to be crossed in record time at the cost of handling, which is moreso \z
    a problem than a benefit in this particular case. Can you adapt to 21st century technology and grab the red coins of the tower of the wing cap?",
    modifiers = {MODIFIERS.TURBO}
}

add_challenge(challenge)