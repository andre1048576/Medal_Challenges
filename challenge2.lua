
-- challenge function returns whether mario has failed the challenge.
---@param m MarioState
local function main_challenge(m)
    execute_mario_action(m.marioObj)
    if m.health < 0x880 then
        return true
    end
end


-- called when the challenge is first started
local function init_challenge()
    warp_to_level(LEVEL_SSL,2,3)
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
    index = "VN2",
    medal = MEDALS.YELLOW,
    star = 2,
    name = "Inside the ancient pyramid",
    description = "You've accidentally slipped into the pyramid when trying to get 'Shining atop the pyramid'; You usually skip this star with the four pillars outside \z
    considering how simple this star is, but that's hardly an option at the moment. To get it over with ASAP, you've enabled your fancy emulator speedup, doubling the game speed. \z
    Eyerok, sensing this blatant cheating, curses you to die in a single hit inside the pyramid. Can you dodge the ancient pyramid's dastardly traps quickly... with perfection?",
    modifiers = {MODIFIERS.TURBO,MODIFIERS.DAREDEVIL}
}

add_challenge(challenge)