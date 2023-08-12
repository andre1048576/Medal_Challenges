
-- challenge function returns whether mario has failed the challenge.
---@param m MarioState
local function main_challenge(m)
    if m.action == 6436 then return end
    local koopaObj
    local o = obj_get_first_with_behavior_id(id_bhvKoopa)
    if not o then return end
    if o.oBehParams2ndByte == 3 then
        koopaObj = o
    else
        koopaObj = obj_get_next_with_same_behavior_id(o)
    end
    if m.action & ACT_GROUP_AIRBORNE == 0 and ((dist_between_objects(m.marioObj,koopaObj) > 300 and koopaObj.oPosZ > -6000) or (koopaObj.oVelX ~= 0 or koopaObj.oVelY ~= 0 or koopaObj.oVelZ ~= 0)) then
        m.action = ACT_JUMP
        m.faceAngle.y = m.intendedYaw
        m.vel.y = 50
        m.forwardVel = 50
    end
end


-- called when the challenge is first started
local function init_challenge()
    warp_to_level(LEVEL_THI,1,3)
end

local function init_level()
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
    init_level = init_level,
    index = "VN17",
    medal = MEDALS.YELLOW,
    star = 2,
    name = "Rematch with Koopa the Quick",
    description = "Koopa the Quick, after his previous humiliating loss, has asked for a rematch on his home turf. Considering you haven't been here since your last playthrough, you would get absolutely smoked \z
    by Koopa the Quick. That's why you've brought an important powerup capable of crossing impossible obstacles: a spring mushroom. Despite it's uncontrolability, the spring mushroom allows for feats that are \z
    sure to help you outpace Koopa the Quick. Can you get to grips with both the spring mushroom and Koopa the Quick?",
    modifiers = {MODIFIERS.MIXEDMARIO}
}

add_challenge(challenge)