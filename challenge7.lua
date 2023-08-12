
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
    warp_to_level(LEVEL_HMC,1,6)
    allowed_presses = 2
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

local function hud_render()
    local msg = allowed_presses .. " / 2"
    local scale = 6
    local msg_width = djui_hud_measure_text(msg)
    local x_left = djui_hud_get_screen_width()-msg_width*scale-30
    local y_top = djui_hud_get_screen_height()-25*scale - 100
    local width = msg_width*scale
    local height = 25*scale
    djui_hud_set_color(0,0,0,255)
    djui_hud_render_rect(x_left-15,y_top - 15 - scale,width + 30,height + 30 + 2*scale)
    djui_hud_reset_color()
    djui_hud_print_text(msg,x_left,y_top,scale)
    djui_hud_print_text("A presses left",x_left +width/4,y_top-2*scale,scale/5)
end

---@type challenge
local challenge = {
    init = init_challenge,
    challenge = main_challenge,
    criteria = challenge_criteria,
    hud_render = hud_render,
    index = "VN7",
    medal = MEDALS.YELLOW,
    star = 5,
    name = "Watch for rolling rocks",
    description = "You've recently watched a really cool video by pannenkoek2012 called `Watch for Rolling Rocks in 0.5x A presses`. The video elicited a singular reaction \z 
    from you: 'Boy, I could do that.' Now that you've reached the titular star, it's time to figure out how the A button challenge works here. Pannenkoek2012 explained that a \z
    0.5x A press is rounded up to 1x in a single star run, and you're obviously capable of doing it like this, but for the sake of your upcoming 12 hours you've allowed yourself \z
    an additional A press. Can you Watch for Rolling Rocks in 2x A presses?",
    modifiers = {MODIFIERS.ABC}
}

add_challenge(challenge)