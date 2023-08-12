

-- challenge function returns whether mario has failed the challenge.
---@param m MarioState
local function main_challenge(m)
    if challenge_timer < 6 then
        m.pos.y = 205
        m.pos.x = 1985
        m.pos.z = 297
    end
    if (m.input & INPUT_IN_POISON_GAS) > 0 then
        m.health = m.health - 0x040
    end
end


-- called when the challenge is first started
local function init_challenge()
    warp_to_level(LEVEL_HMC,1,4)
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
    if it == INTERACT_COIN then
        m.healCounter = 0
    end
end

---@type challenge
local challenge = {
    init = init_challenge,
    challenge = main_challenge,
    criteria = challenge_criteria,
    on_interact = on_interact,
    index = "VN8",
    medal = MEDALS.RED,
    star = 3,
    name = "Navigating the Toxic Maze",
    description = "It's been quite a while since your last playthrough, and Hazy Maze Cave is still as hazy as ever. That much haze must mean that the poison density has raised 5 fold since the last time you've been here. \z 
    Prepare to take massive damage as you venture into the maze's poison. The residual poison all across the cave has also stuck to you, preventing any recovery while you fetch the medal and disabling the effects of the metal cap. \z
    Can you dash through the maze to the exit with your lungs intact?",
    modifiers = {MODIFIERS.NOHEAL,MODIFIERS.MIXEDENV}
}

add_challenge(challenge)