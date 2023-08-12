
local allowed_presses

-- challenge function returns whether mario has failed the challenge.
---@param m MarioState
local function main_challenge(m)
    if m.controller.buttonPressed & A_BUTTON ~= 0 then
        allowed_presses = allowed_presses - 1
    end
    if allowed_presses < 0 then
        return true
    end
end


-- called when the challenge is first started
local function init_challenge()
    warp_to_level(LEVEL_RR,1,3)
    allowed_presses = 14
end

local function hud_render()
    local msg = allowed_presses .. " / 14"
    local scale = 6
    local msg_width = djui_hud_measure_text("14 / 14")
    local width = msg_width*scale
    local height = 25*scale
    local x_left = djui_hud_get_screen_width()-msg_width*scale-30
    local y_top = djui_hud_get_screen_height()-25*scale - 100 - height - 50
    djui_hud_set_color(0,0,0,255)
    djui_hud_render_rect(x_left-15,y_top - 15 - scale,width + 30,height + 30 + 2*scale)
    djui_hud_reset_color()
    djui_hud_print_text(msg,x_left,y_top,scale)
    djui_hud_print_text("A presses left",x_left +width/4,y_top-2*scale,scale/5)
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
    hud_render = hud_render,
    index = "VN18",
    medal = MEDALS.RED,
    speedrun_frame_limit = 1650,
    star = 2,
    name = "Coins amassed in a maze",
    description = "For being in the final mission, this star was always somehow the easiest one. There are few obstables; it's the closest to the entrance of the level; \z
    and both the coins within the maze and the nearby heart ensure you don't run out of health. You're obviously getting no better at \z
    Super Mario 64 doing this star the intended way, so how about you challenge yourself a little? The core appeal of Mario's moveset lies in his mobility, so let's \z
    make sure you're mobile with a 55 second time limit. To make sure you stay in the flow, let's limit the number of times you can fail the jumps in the maze with a 14 A press \z
    limit. Can you collect the red coins while improving your flow?",
    modifiers = {MODIFIERS.SPEEDRUN,MODIFIERS.ABC}
}

add_challenge(challenge)