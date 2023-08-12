

-- challenge function returns whether mario has failed the challenge.
---@param m MarioState
local function main_challenge(m)
    return challenge_timer >= 900
end

-- called when the challenge is first started
local function init_challenge()
    warp_to_level(LEVEL_TTM,1,1)
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
    index = "VN9",
    medal = MEDALS.BLUE,
    speedrun_frame_limit = 900,
    star = 0,
    name = "Scale the mountain",
    description = "Tall Tall Mountain is an incredibly repetitive level. The stars within the course are, in order: climbing the mountaintop, climbing the mountaintop and \z
    grabbing a monkey, the obligatory red coin mission, climbing the mountaintop and jumping into a slide level, climbing the mountaintop and jumping into a waterfall, and \z
    a star on a mushroom everyone collects by climbing the mountain. To get the course done ASAP, you'll need to learn how to climb the mountain quickly. Assuming no glitches, 30 \z
    seconds is a plenty fast time to climb to the top and grab the first star available. Can you overcome the mountain with extreme speed?",
    modifiers = {MODIFIERS.SPEEDRUN}
}

add_challenge(challenge)