
-- challenge function returns whether mario has failed the challenge.
---@param m MarioState
local function main_challenge(m)
    if m.controller.buttonPressed & A_BUTTON ~= 0 then
        return true
    end
end


-- called when the challenge is first started
local function init_challenge()
    warp_to_level(LEVEL_BOB,1,1)
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
    index = "VN1",
    medal = MEDALS.GREEN,
    star = 0,
    name = "Big bob-omb on the summit",
    description = "It's been a while since you've played Super Mario 64, and you've been hearing about this 'ex-coop' mode on a pc version. \z
    To make sure you're ready, you've booted up a legally obtained copy of Super Mario 64 on an emulator and grabbed an old controller from \z
    your closet to do a casual playthrough. Things are already off to a bad start however, as the leftover dust in the controller has \z
    caused the A button to no longer work for the time being! Can you actually beat the Big Bob-omb as your first star for once with the most \z
    important button Missing In ction?",
    modifiers = {MODIFIERS.ABC}
}

add_challenge(challenge)