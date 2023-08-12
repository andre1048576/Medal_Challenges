-- challenge function returns whether mario has failed the challenge.


local secret_collected

---@param m MarioState
local function main_challenge(m)
    if challenge_timer < 8 and m.action == ACT_METAL_WATER_FALLING then
        m.pos.y = 100
    end
    if (not secret_collected) and obj_count_objects_with_behavior_id(id_bhvHiddenStarTrigger) == 4 then
        secret_collected = true
        spawn_non_sync_object(id_bhvBreakableBox,E_MODEL_BREAKABLE_BOX,2458,600,-740,function() end)
        spawn_non_sync_object(id_bhvBreakableBox,E_MODEL_BREAKABLE_BOX,1824,400,-500,function() end)
        play_puzzle_jingle()
    end
    m.capTimer = 10
    m.flags = m.flags | MARIO_METAL_CAP
    set_environment_region(1,5000)
end


local function level_init()
    local o = obj_get_first_with_behavior_id(id_bhvWaterLevelDiamond)
    while o do
        obj_mark_for_deletion(o)
        o = obj_get_first_with_behavior_id(id_bhvWaterLevelDiamond)
    end
    o = obj_get_first_with_behavior_id(id_bhvFadingWarp)
    while o do
        obj_mark_for_deletion(o)
        o = obj_get_first_with_behavior_id(id_bhvFadingWarp)
    end
end

-- called when the challenge is first started
local function init_challenge()
    warp_to_level(LEVEL_WDW,1,1)
    secret_collected = false
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

---@param o Object
local function on_interact(m,o,it)
    if m.action == ACT_METAL_WATER_JUMP and obj_has_behavior(o,get_behavior_from_id(id_bhvExclamationBox)) > 0 and it == INTERACT_BREAKABLE and o.oAction < 3 then
        o.oAction = 3
    end
end

---@type challenge
local challenge = {
    init = init_challenge,
    challenge = main_challenge,
    criteria = challenge_criteria,
    level_init = level_init,
    on_interact = on_interact,
    index = "VN6",
    medal = MEDALS.YELLOW,
    star = 0,
    name = "Shocking arrow lifts",
    description = "You've made it to Wet Dry World in your journey to complete Super Mario 64, although you don't recall there being much to this world. Some Heave-hos, some Chuckyas, and some water shenanigans are \z
    all that stuck out previously. The world happens to be more wet than not this time, as when you enter you're immediately put 20000 feet under the sea (Slight exageration)! An idiot would be belated this, as they fruitlessly swim \z
    to a box they cannot open. You're certainly no fool, as you've brought your trusty Perma-Metal-Cap which will allow you to smash open the box for your prized medal. All that remains is how you'll reach the Shocking Arrow Lifts. \z
    Can you find the secret of the shallows and skies that will allow you to climb the insurmountable?",
    modifiers = {MODIFIERS.MIXEDENV,MODIFIERS.MIXEDMARIO}
}

add_challenge(challenge)