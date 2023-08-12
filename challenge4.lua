
-- challenge function returns whether mario has failed the challenge.
---@param m MarioState
local function main_challenge(m)
    if m.health < 0x880 then
        return true
    end
end

local r = 400
local chain_chomp_positions = {
{250 + r * math.cos(math.rad(0)),735,1920 + r * math.sin(math.rad(0)) + 600},
{250 + r * math.cos(math.rad(120)),735,1920 + r * math.sin(math.rad(120))},
{250 + r * math.cos(math.rad(240)),735,1920 + r * math.sin(math.rad(240)) + 150}
}

local function level_init()
    local o = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj,id_bhvBobomb)
    while o do
        obj_mark_for_deletion(o)
        o = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj,id_bhvBobomb)
    end
    o = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj,id_bhvChainChomp)
    for _,v in pairs(chain_chomp_positions) do
        spawn_non_sync_object(id_bhvChainChomp,E_MODEL_CHAIN_CHOMP,v[1],735,v[3],function() end)
        spawn_non_sync_object(id_bhvFlame,E_MODEL_BLUE_FLAME,v[1],985,v[3],function () end)
    end
    gate = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj,id_bhvChainChompGate)
    gate.parentObj = o
end


-- called when the challenge is first started
local function init_challenge()
    warp_to_level(LEVEL_BOB,1,6)
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
    level_init = level_init,
    index = "VN4",
    medal = MEDALS.RED,
    star = 5,
    name = "Behind chain chomp's gate",
    description = "Great news: It's been long enough since you've defeated the leader that the hostile bob-ombs have now left the level. \z
    Less great news: Chain Chomps have been able to take over the battlefield using their power star and are now fiercely guarding their star. They're so vicious that they'll \z
    tear you to shreads in a single bite! Can you handle the chain chomps' Kaizo level threat with your limbs intact and a new star?",
    modifiers = {MODIFIERS.MIXEDENV,MODIFIERS.DAREDEVIL}
}

add_challenge(challenge)