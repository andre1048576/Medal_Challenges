
-- challenge function returns whether mario has failed the challenge.
---@param m MarioState
local function main_challenge(m)
    if m.action & ACT_FLAG_AIR ~= 0 and m.heldObj ~= nil then
        return true
    end
end


-- called when the challenge is first started
local function init_challenge()
    warp_to_level(LEVEL_CCM,1,2)
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
    index = "VN3",
    medal = MEDALS.GREEN,
    star = 1,
    name = "Li'l penguin lost",
    description = "You've been contacted by the mushroom kingdom's postal service to deliver a high-tech penguin-shaped alarm clock to the wealthiest penguin this side of Cool Cool Mountain. \z
    The clock has impressive fall resistance, but at the cost of a vulnerability when jostled. Considering your lack of control in midair, this means you cannot leave the ground holding the \z
    package. Can you ensure the package's delivery without your jumps, jumpman?",
    modifiers = {MODIFIERS.GROUNDED}
}

add_challenge(challenge)