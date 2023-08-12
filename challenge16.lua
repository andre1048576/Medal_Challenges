local entered_cannon
-- challenge function returns whether mario has failed the challenge.
---@param m MarioState
local function main_challenge(m)
    if challenge_timer < 5 then return false end
    if m.action == ACT_SHOT_FROM_CANNON then
        entered_cannon = true
    end
    --i drew an invisible wall between the rest of the level and the star
    if (not entered_cannon) and (m.pos.x + m.pos.z/6 > 6500) then
        m.action = ACT_AIR_HIT_WALL
    end
end


-- called when the challenge is first started
local function init_challenge()
    warp_to_level(LEVEL_TTM,1,6)
    entered_cannon = false
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
    index = "VN16",
    medal = MEDALS.GREEN,
    star = 5,
    name = "Blast to the lonely mushroom",
    description = "You've made it to the final mission of TTM, and it's quite a challenge... when done the intended way. However, i've not seen a single one of you actually blast \z 
    to the lonely mushroom. Instead, all of you just jump down from the log, or the top, or use the fly guy even. Now, you're going to do the star as intended. This is the vanilla star. \z
    Just collect the star. There are no modifiers in the way from you and collecting the star as intended. Can you collect the star the dev intended way?",
    modifiers = {}
}

add_challenge(challenge)