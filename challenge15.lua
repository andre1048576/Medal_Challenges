local spawned_coins
-- challenge function returns whether mario has failed the challenge.
---@param m MarioState
local function main_challenge(m)
    if m.action ~= 6436 and m.action & ACT_FLAG_AIR ~= 0 then
        m.health = m.health - 0x18
    end
    if gNetworkPlayers[0].currAreaIndex == 2 and not spawned_coins then
        spawned_coins = true
        spawn_non_sync_object(id_bhvCoinFormation,E_MODEL_NONE,-3,400,-600,function (o) o.oFaceAngleYaw = 0x10000 end)
    end
end


-- called when the challenge is first started
local function init_challenge()
    warp_to_level(LEVEL_SSL,1,1)
    spawned_coins = false
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
    index = "VN15",
    medal = MEDALS.RED,
    star = 3,
    name = "Stand tall on the four pillars",
    description = "There have been reports lately that Eyerock has been cursing travelers to the Shifting Sand Land with his various ancient curses. \z
    Your suspicions are immediately confirmed when you arrive to investigate, as Eyerock places an aerial ward on you, inflicting heavy damage while airborne. \z
    This obviously cannot stand, and Eyerock cannot be allowed to continue his abuse of power on the desert. Can you defeat Eyerock with one of his curses on you?",
    modifiers = {MODIFIERS.GROUNDED}
}

add_challenge(challenge)