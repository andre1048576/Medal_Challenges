-- challenge function returns whether mario has failed the challenge.

---@param m MarioState
local function main_challenge(m)
    set_environment_region(1,-10000)
    local o = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj,id_bhvWaterLevelDiamond)
    while o do
        obj_mark_for_deletion(o)
        o = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj,id_bhvWaterLevelDiamond)
    end
end

local function level_init()
    local o = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj,id_bhvFadingWarp)
    while o do
        obj_mark_for_deletion(o)
        o = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj,id_bhvFadingWarp)
    end
    --spawn_non_sync_object(id_bhvWdwSquareFloatingPlatform,E_MODEL_WDW_SQUARE_FLOATING_PLATFORM,-2550,3340,3200,function () end)
end

-- called when the challenge is first started
local function init_challenge()
    warp_to_level(LEVEL_WDW,1,5)
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
    level_init = level_init,
    on_interact = on_interact,
    index = "VN5",
    medal = MEDALS.YELLOW,
    star = 4,
    name = "Go to town for red coins",
    description = "After spending enough time in Wet Dry World, the reported `negative aura` of the place is starting to settle in. This aura has affected your ability to heal, rendering coins and the water's surface meaningless. \z
    Not healing from the water isn't as bad as it sounds, however, as all of the water in the area has been drained. The most likely cause of this is the town under, so investigate there first. \z
    Can you collect the dried town's 8 red coins under the influence of the negative aura?",
    modifiers = {MODIFIERS.MIXEDENV,MODIFIERS.NOHEAL}
}

add_challenge(challenge)