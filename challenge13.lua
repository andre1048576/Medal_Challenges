local i
local positions = {{-1312,512,7347}
,{7121,-3478,2121}
,{-221,-2966,-6600}
,{4933,1536,6402}}

local angles = {
    28223,
    -13555,
    -16535,
    -24770
}

local j = {4,3,1,2}

-- challenge function returns whether mario has failed the challenge.
---@param m MarioState
local function main_challenge(m)
    if i == 1 then
        local o = obj_get_first_with_behavior_id(id_bhvTreasureChestBottom)
        -- restart level read from the chests before they were initialized (with my custom positions), so the chest spawner would move them to their intended spots again
        if not o or o.oPosX ~= -1700 then return end
        while o do
            o.oPosX = positions[j[i]][1]
            o.oPosY = positions[j[i]][2]
            o.oPosZ = positions[j[i]][3]
            o.oFaceAngleYaw = angles[j[i]]
            o = obj_get_next_with_same_behavior_id(o)
            i = i + 1
        end
    end
end

-- called when the challenge is first started
local function init_challenge()
    i = 1
    warp_to_level(LEVEL_JRB,1,3)
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
    index = "VN13",
    medal = MEDALS.GREEN,
    star = 2,
    name = "Treasure Chests of the cave",
    description = "Tales tell that a set of treasure chests that hold great power an- no i'm not talking about the ones in the ship \z 
    those are a glorified water diamond. Anyways, this treasure lies dormant in a cave undiscov- do you mean to tell me \z
    it's been discovered? Apparently some pirates managed to discover the cave and the treasure chests, but not the treasure. They've left \z
    the chests strewn about the bay, and now you have to figure out how to open them. Can you collect the treasure the pirates couldn't?",
    modifiers = {MODIFIERS.MIXEDENV}
}

add_challenge(challenge)