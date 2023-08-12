djui_hud_set_resolution(RESOLUTION_DJUI)
---@type Menu[]
local rendered_menus = {}


---@param menu Menu
local function add_menu(menu)
    table.insert(rendered_menus,menu)
end

local function pop_menu()
    local curr_menu = table.remove(rendered_menus,#rendered_menus)
    if curr_menu.on_clear then
        curr_menu.on_clear()
    end
end

local function clear_menu()
    while #rendered_menus > 1 do
        pop_menu()
    end
end


---@type integer
local selected_challenge_index = 1

---@type string[]
challenge_ordering = {"VN1","VN4","VN11","VN13","VN3","VN12","VN8","VN7","VN0","VN2","VN15","VN10","VN6","VN5","VN9","VN16","VN17","VN19","VN18","VN14"}
--CHALLENGE ELEMENT

local description_height_min = 0
local description_height_max = 300
local description_height = 0
local description_modifier = 0
local description_speed = 10

local function challenge_element_input(buttonPressed)
    if buttonPressed & B_BUTTON ~= 0 then
        pop_menu()
        description_modifier = -description_speed
        return true
    end
    if buttonPressed & A_BUTTON ~= 0 then
        --this is the part where you warp
        set_challenge(challenge_ordering[selected_challenge_index])
        clear_menu()
        return true
    end
end

local function challenge_element_render()
    
end

---@type Menu
local challenge_element = {input = challenge_element_input,render = challenge_element_render}



--CHALLENGE LIST

local widthPercentage = 0.6
local heightPercentage = 0.75




---@param buttonPressed integer
local function challenge_list_input(buttonPressed)
    if buttonPressed & A_BUTTON ~= 0 then
        if description_height == 0 then
            description_modifier = description_speed
            add_menu(challenge_element)
        end
    end
    --prevent all input if the blue screen is up
    if description_height == 0 then
        
        if buttonPressed & D_JPAD ~= 0 then
            selected_challenge_index = bounded_increment(selected_challenge_index,1,#challenge_ordering,1)
            return true
        end
        if buttonPressed & U_JPAD ~= 0 then
            selected_challenge_index = bounded_increment(selected_challenge_index,1,#challenge_ordering,-1)
            return true
        end
        if buttonPressed & B_BUTTON ~= 0 then
            pop_menu()
            return true
        end
        
    end
    
end

---@param description string
---@param max_width integer
function description_to_lines(description,max_width)
    local lol = {}
    local line_start = 1
    local space_index = description:find(" ",line_start)
    local previous_space_index
    if not space_index then return {description} end
    while djui_hud_measure_text(description:sub(line_start)) > max_width do
        while djui_hud_measure_text(description:sub(line_start,space_index)) <= max_width do
            previous_space_index = space_index
            space_index = description:find(" ",space_index+1)
            if not space_index then
                break
            end
        end
        table.insert(lol,description:sub(line_start,previous_space_index))
        line_start = previous_space_index+1
    end
    table.insert(lol,description:sub(line_start))
    return lol
end

---@type table<Modifier,string>
modifiers_to_string = {[MODIFIERS.ABC] = "a_button",[MODIFIERS.DAREDEVIL] = "daredevil",[MODIFIERS.GROUNDED] = "grounded",[MODIFIERS.SPEEDRUN] = "speedrun",
[MODIFIERS.MIXEDENV] = "mixedenv",[MODIFIERS.MIXEDMARIO] = "mixedmario",[MODIFIERS.NOHEAL] = "noheal",[MODIFIERS.TURBO] = "turbo"}

---@type table<Medal,string>
medal_to_string_icon = {[MEDALS.BLUE] = "medalblue",[MEDALS.GREEN] = "medalgreen",[MEDALS.YELLOW] = "medalyellow",[MEDALS.RED] = "medalred"}

local function challenge_list_render()
    width = djui_hud_get_screen_width()*widthPercentage
    height = djui_hud_get_screen_height()*heightPercentage
    left = (djui_hud_get_screen_width()-width)/2
    top = (djui_hud_get_screen_height()-height)/2
    djui_hud_set_color(0x10,0x82,0x22,255)
    djui_hud_render_rect(left,top,width,height)
    local currY = 0.01
    local horizontal_padding = 0.05*width
    local vertical_element_height = 0.1*height
    local vertical_padding = 0.01
    local text_horizontal_padding = 0.02*width
    local orderedIndexToRender = bounded_increment(selected_challenge_index,1,#challenge_ordering,-1)
    local textHeight = 34
    local endY = 0

    while true do
        endY = currY + vertical_element_height/height
        if endY > 1 then break end
        currTop = currY*height
        challenge_to_render = get_challenge(challenge_ordering[orderedIndexToRender])
        --draw background rectangle
        djui_hud_set_color(0x79,0xef,0x8b,255)
        djui_hud_render_rect(left + horizontal_padding,top + currTop,width - 2*horizontal_padding,vertical_element_height)
        --add glove
        verticalCenter = top + currTop + vertical_element_height/2 - textHeight/2
        if selected_challenge_index == orderedIndexToRender then
            djui_hud_set_color(255,255,255,255)
            djui_hud_render_texture(get_texture_info("glove"),left + horizontal_padding/8,verticalCenter,3,3)
        end
        --render title
        djui_hud_set_color(0,0,0,255)
        djui_hud_print_text(challenge_to_render.name,left + horizontal_padding + text_horizontal_padding,verticalCenter,1)
        local text_length = djui_hud_measure_text(challenge_to_render.name)

        --render medal
        local medal_ressource = medal_to_string_icon[challenge_to_render.medal]
        if not mod_storage_load(challenge_to_render.index) then
            medal_ressource = medal_ressource .. "_uncollected"
        else
            local txt = frames_to_time(tonumber(mod_storage_load(challenge_to_render.index)))
            djui_hud_print_text(txt,left + 0.92*width - horizontal_padding - djui_hud_measure_text(txt),verticalCenter,1)
        end

        --render modifiers
        djui_hud_set_color(255,255,255,255)
        for i,v in pairs(challenge_to_render.modifiers) do
            djui_hud_render_texture(get_texture_info(modifiers_to_string[v]),text_length + left + horizontal_padding + text_horizontal_padding + 20 + 50*(i-1),verticalCenter,3,3)
        end
        
        djui_hud_render_texture(get_texture_info(medal_ressource),left + 0.94*width - horizontal_padding,verticalCenter,3,3)

        --show description
        if description_height > 0 and selected_challenge_index == orderedIndexToRender then
            djui_hud_set_color(0x32,0xab,0xf0,255)
            djui_hud_render_rect(left + horizontal_padding,top + currY*height + vertical_element_height,width - 2*horizontal_padding,description_height)
            local lines = description_to_lines(challenge_to_render.description,width - 2*horizontal_padding - text_horizontal_padding)
            djui_hud_set_color(0,0,0,255)
            description_height_max = #lines*textHeight+100
            for i = 1, description_height//textHeight do
                if not lines[i] then break end
                djui_hud_print_text(lines[i],left + horizontal_padding + text_horizontal_padding,top + currY*height + vertical_element_height + vertical_padding*height + textHeight*(i-1),1)
            end
            endY = endY + description_height/height
            if description_height == description_height_max then
                --render A and B buttons
                local y = description_height + top + currY*height + vertical_element_height - 50
                djui_hud_set_color(255,255,255,255)
                djui_hud_render_texture(get_texture_info("medalblue"),left + horizontal_padding + text_horizontal_padding + width*0.05,y,3,3)
                djui_hud_render_texture(get_texture_info("medalred"),left + horizontal_padding + text_horizontal_padding + width*0.55,y,3,3)
                djui_hud_set_color(0,0,0,255)
                djui_hud_print_text("Enter",left + horizontal_padding + text_horizontal_padding + width*0.05 + 2*textHeight,y - textHeight/2,2)
                djui_hud_print_text("Cancel",left + horizontal_padding + text_horizontal_padding + width*0.55 + 2*textHeight,y - textHeight/2,2)
            end
        end
        currY = endY + vertical_padding
        orderedIndexToRender = bounded_increment(orderedIndexToRender,1,#challenge_ordering,1)
    end
end

local function challenge_list_clear()
    description_modifier = 0
    description_height = 0
end

---@type Menu
local challenge_list = {input = challenge_list_input,render = challenge_list_render,on_clear = challenge_list_clear}


--TOP MENU RENDER

---@param buttonPressed integer
local function top_menu_input(buttonPressed)
    if not current_challenge then
        if buttonPressed & Y_BUTTON ~= 0 then
            if #rendered_menus == 1 then
                add_menu(challenge_list)
            else
                clear_menu()
            end
            return true
        end
    end
    --auto retry button
    if #rendered_menus == 1 then
        if buttonPressed & X_BUTTON ~= 0 then
            clear_menu()
            set_challenge(challenge_ordering[selected_challenge_index])
        end
    end
end



--this function deals with any globals that should be edited every frame
local function top_menu_render()
    description_height = description_height + description_modifier
    if description_height >= description_height_max then
        description_height = description_height_max
        description_modifier = 0
    elseif description_height <= description_height_min then
        description_height = description_height_min
        description_modifier = 0
    end
end

---@type Menu
local top_menu = {input = top_menu_input,render = top_menu_render}

function render_medal_screen()
    local buttonPressed = gMarioStates[0].controller.buttonPressed
    if buttonPressed ~= 0 then
        for i = #rendered_menus,1,-1 do
            if rendered_menus[i].input(buttonPressed) then
                break
            end
        end
    end
    for _,v in ipairs(rendered_menus) do
        v.render()
    end
end

add_menu(top_menu)

hook_event(HOOK_ON_HUD_RENDER,render_medal_screen)


--ensure mario can't move while in the menu

local allowed_actions = {[67110000] = true,[132199] = true}

---comment
---@param m MarioState
---@param a any
function b4_set_action(m,a)
    if #rendered_menus == 1 then return end
    if m.flags & ACT_GROUP_AIRBORNE == 0 and not allowed_actions[a] then
        return 1
    end
end

hook_event(HOOK_BEFORE_SET_MARIO_ACTION,b4_set_action)