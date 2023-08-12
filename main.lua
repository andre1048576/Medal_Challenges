-- name: Medal Challenges
-- description: Collect 20 varied medals across various stages Author: andre8739

local function obj_is_star(o)
    return (obj_has_model_extended(o,E_MODEL_STAR) ~= 0 or obj_has_model_extended(o,E_MODEL_TRANSPARENT_STAR) ~= 0)
end

local function obj_is_not_star_marker(o)
    return obj_has_behavior(o,get_behavior_from_id(id_bhvRedCoinStarMarker)) == 0
end

local function obj_is_celebration_star(o)
    return obj_has_behavior(o,get_behavior_from_id(id_bhvCelebrationStar)) ~= 0
end

local challenge_cleared

---@param m MarioState
local function challenge_mario_update(m)
    if not current_challenge then return end
    if m.playerIndex ~= 0 then return end
    --challenge return whether the player has failed the challenge
    if current_challenge.challenge(m) or not current_challenge then
        m.health = 0
        clear_challenge()
        return
    end
    --because current_challenge.challenge can cause current_challenge to become null when mario dies in it, we need another nil check
    --challenge criteria returns whether the player has succeeded the challenge
    challenge_cleared = current_challenge.criteria(m)
    if challenge_cleared then
        local previous_score = tonumber(mod_storage_load(current_challenge.index))
        if not (previous_score and previous_score < challenge_timer) then
            mod_storage_save(current_challenge.index,challenge_timer .. "")
        end
        clear_challenge()
        return
    end

    if obj_is_star(m.interactObj) then
        clear_challenge()
    end
end

local toggle = true

---@param o Object
local function medal_enable(o)
    if current_challenge then
        if obj_is_star(o) and obj_is_not_star_marker(o) and (o.oBehParams >> 24) == current_challenge.star and (not obj_is_celebration_star(o)) then
            obj_set_model_extended(o,get_model(current_challenge.medal))
        end
    elseif challenge_cleared then
        if obj_is_star(o) and obj_is_celebration_star(o) then
            obj_set_model_extended(o,get_model(last_medal()))
            toggle = not toggle
            if toggle then
                challenge_cleared = false
            end
        end
    end
end



local function on_death()
    clear_challenge()
end

local function on_pause_exit()
    clear_challenge()
    return true
end

local function on_level_init()
    if not current_challenge then return end
    if not current_challenge.level_init then return end
    return current_challenge.level_init()
end

local function on_interact(m,o,it)
    if not current_challenge then return end
    if not current_challenge.on_interact then return end
    return current_challenge.on_interact(m,o,it)
end

local function on_hud_render()
    if not current_challenge then return end
    if not current_challenge.hud_render then return end
    return current_challenge.hud_render()
end

local function before_set_mario_action(m,a)
    if not current_challenge then return end
    if not current_challenge.before_set_mario_action then return end
    return current_challenge.before_set_mario_action(m,a)
end

local function timer_count()
    if not current_challenge then return end
    challenge_timer = challenge_timer + 1
end

local function format_number(num)
    if num < 10 then return "0" .. num else return num .. "" end
end

function frames_to_time(frames)
    if frames <= 0 then return "00`00`00" end
    local str = ""
    local minutes = frames//1800
    str = str .. format_number(minutes) .. "`"
    frames = frames % 1800
    local seconds = frames//30
    str = str .. format_number(seconds) .. "`"
    frames = frames%30
    str = str .. format_number(frames*10//3)
    return str
end

local function speedrun_timer()
    if not current_challenge then return end
    if not current_challenge.speedrun_frame_limit then return end
    local msg = frames_to_time(current_challenge.speedrun_frame_limit - challenge_timer)
    local scale = 6
    local msg_width = djui_hud_measure_text("00`00`00")
    local x_left = djui_hud_get_screen_width()-msg_width*scale-30
    local y_top = djui_hud_get_screen_height()-25*scale - 100
    local width = msg_width*scale
    local height = 25*scale
    djui_hud_set_color(0,0,0,255)
    djui_hud_render_rect(x_left-15,y_top - 15 - scale,width + 30,height + 30 + 2*scale)
    djui_hud_reset_color()
    djui_hud_print_text(msg,x_left,y_top,scale)
    djui_hud_print_text("Time Remaining",x_left +width/4,y_top-2*scale,scale/5)
end



hook_event(HOOK_MARIO_UPDATE,challenge_mario_update)

hook_event(HOOK_OBJECT_SET_MODEL,medal_enable)

hook_event(HOOK_ON_PAUSE_EXIT,on_pause_exit)

hook_event(HOOK_ON_DEATH,on_death)

hook_event(HOOK_ON_LEVEL_INIT,on_level_init)

hook_event(HOOK_UPDATE,timer_count)

hook_event(HOOK_ON_INTERACT,on_interact)

hook_event(HOOK_ON_HUD_RENDER,on_hud_render)

hook_event(HOOK_ON_HUD_RENDER,speedrun_timer)

hook_event(HOOK_BEFORE_SET_MARIO_ACTION,before_set_mario_action)