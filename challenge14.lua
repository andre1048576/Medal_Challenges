-- challenge function returns whether mario has failed the challenge.
---@param m MarioState
local function main_challenge(m)
    if m.hurtCounter > 0 then
        return true
    end
end


-- called when the challenge is first started
local function init_challenge()
    change_challenge_star("VN14",2-1)
    warp_to_level(LEVEL_BOB,1,2)
end

warp_data = {
[LEVEL_BOB] = {LEVEL_WF ,1,2},
[LEVEL_WF]  = {LEVEL_JRB,1,5},
[LEVEL_JRB] = {LEVEL_CCM,1,5},
[LEVEL_CCM] = {LEVEL_BBH,1,3},
[LEVEL_BBH] = {LEVEL_HMC,1,5},
[LEVEL_HMC] = {LEVEL_LLL,1,2},
[LEVEL_LLL] = {LEVEL_SSL,1,6},
[LEVEL_SSL] = {LEVEL_DDD,1,2},
[LEVEL_DDD] = {LEVEL_SL ,1,4},
[LEVEL_SL]  = {LEVEL_WDW,1,3},
[LEVEL_WDW] = {LEVEL_TTM,1,3},
[LEVEL_TTM] = {LEVEL_THI,1,1},
[LEVEL_THI] = {LEVEL_TTC,1,5},
[LEVEL_TTC] = {LEVEL_RR,1,5},}


-- criteria returns true when the challenge has been completed (almost always collecting a star)
---@param m MarioState
local function challenge_criteria(m)
    local obj = m.interactObj
    if (not obj) or not obj.behavior then return end
    if obj_is_medal(obj) then
        local currLevel = gNetworkPlayers[0].currLevelNum
        if currLevel == LEVEL_RR then
            return true
        end
        change_challenge_star("VN14",warp_data[currLevel][3]-1)
---@diagnostic disable-next-line: param-type-mismatch
        warp_to_level(warp_data[currLevel][1],warp_data[currLevel][2],warp_data[currLevel][3])
    end
end

---@type challenge
local challenge = {
    init = init_challenge,
    challenge = main_challenge,
    criteria = challenge_criteria,
    index = "VN14",
    medal = MEDALS.BLUE,
    star = -1,
    name = "Remix 15",
    description = "You've explored through numerous magical painting worlds and deadly obstacle courses in this playthrough of Super Mario 64. You've also collected at most 3 \z
    stars from any particular world, and that's clearly not enough to defeat Bowser and rescue the princess. You're going to need to revisit every course and collect a star from \z
    each. You also must make certain not to take damage on this endeavor, as the upcoming final bout with Bowser is sure to tire you plenty, and you'll need all the energy you can \z
    get beforehand. Can you collect the final batch of stars with energy to spare?",
    modifiers = {MODIFIERS.DAREDEVIL}
}

add_challenge(challenge)