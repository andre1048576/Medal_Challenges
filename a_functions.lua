

--- @enum Medal
MEDALS = {GREEN = 0,YELLOW = 1,RED = 2,BLUE = 3}

--- @enum Modifier
MODIFIERS = {
    ABC = 0,
    TURBO = 1,
    GROUNDED = 2,
    SPEEDRUN = 3,
    MIXEDENV = 4,
    DAREDEVIL = 5,
    NOHEAL = 6,
    MIXEDMARIO = 7
}

---@type table<string,challenge>
local challenges = {}

---@type challenge?
current_challenge = nil

---@type Medal
local cached_medal


---@param value integer
---@param inclusive_min integer
---@param inclusive_max integer
---@param increment integer
---@return integer
function bounded_increment(value,inclusive_min,inclusive_max,increment)
    if increment > 0 then
        if value + increment > inclusive_max then
            return value + increment - inclusive_max - 1 + inclusive_min
        else
            return value + increment
        end
    else
        if value + increment < inclusive_min then
            return inclusive_max - inclusive_min + value + increment + 1
        else
            return value + increment
        end
    end
end


---@param challenge_index string
---@return challenge
function get_challenge(challenge_index)
    return challenges[challenge_index]
end

function add_challenge(challenge)
    challenges[challenge.index] = challenge
end

function change_challenge_star(ch_num,new_star)
    challenges[ch_num].star = new_star
end

function clear_challenge()
    current_challenge = nil
    gMarioStates[0].interactObj = nil
end

---@param ch_num string
function set_challenge(ch_num)
    reset_mario()
    challenge_timer = 0
    challenges[ch_num].init()
    cached_medal = challenges[ch_num].medal
    current_challenge = challenges[ch_num]
    return true
end


function reset_mario()
    m = gMarioStates[0]
    m.health = 0x880
    m.hurtCounter = 0
    m.action = ACT_FLAG_IDLE
end

--this is only used for the celebration star and should not be used otherwise
function last_medal()
    return cached_medal
end

---@type table<Medal,ModelExtendedId>
Medals = {[MEDALS.GREEN] = smlua_model_util_get_id("green_medal_geo"), [MEDALS.YELLOW] = smlua_model_util_get_id("yellow_medal_geo"),[MEDALS.RED] = smlua_model_util_get_id("red_medal_geo"), [MEDALS.BLUE] = smlua_model_util_get_id("blue_medal_geo")}

function get_model(medal_type)
    return Medals[medal_type]
end

---@return boolean
function obj_is_medal(o)
    return obj_has_model_extended(o,get_model(current_challenge.medal)) > 0
end

---@param medal_type Medal
---@return integer
function medal_count(medal_type)
    local i = 0
    for _,v in pairs(challenges) do
        if v.medal == medal_type then
            i = i + 1
        end
    end
    return i
end



function print_mario_interact_obj(m)
    local obj = m.interactObj
    if (not obj) or not obj.behavior then return end
end

--hook_event(HOOK_MARIO_UPDATE,print_mario_interact_obj)

--temporary command
hook_chat_command("set","sets what challenge you're doing.",set_challenge)