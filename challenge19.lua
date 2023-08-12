-- challenge function returns whether mario has failed the challenge.
---@param m MarioState
local function main_challenge(m)
    execute_mario_action(m.marioObj)
end


-- called when the challenge is first started
local function init_challenge()
    warp_to_level(LEVEL_TTC,1,4)
    set_ttc_speed_setting(TTC_SPEED_RANDOM)
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

local function before_set_mario_action(m,a)
    if a == ACT_WALL_KICK_AIR then
        return 1
    end
    if a == ACT_DOUBLE_JUMP or a == ACT_SIDE_FLIP or a == ACT_BACKFLIP or a == ACT_LONG_JUMP then
        return ACT_JUMP
    end
    if a == ACT_SLIDE_KICK then
        return ACT_IDLE
    end
end

---@type challenge
local challenge = {
    init = init_challenge,
    challenge = main_challenge,
    criteria = challenge_criteria,
    before_set_mario_action = before_set_mario_action,
    index = "VN19",
    medal = MEDALS.BLUE,
    star = 3,
    name = "Stomp on the Thwomp",
    description = "Your latest trip to Tick Tock Clock has been interrupted by a stray space particle! Instead of an upwarp, this particle has \z
    managed to disable most of mario's jumps while doubling his movement speed and caused the clock to run in the 'random' setting despite the fact that you so obviously jumped in at the 3 mark, \z
    right? You've got 1000$ of mettle to deal with these wacky effects. Can you Stomp on the Thwomp in this wild environment with a considerably nerfed mario?",
    modifiers = {MODIFIERS.TURBO,MODIFIERS.MIXEDMARIO}
}

add_challenge(challenge)