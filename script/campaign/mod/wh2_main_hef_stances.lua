
local hef_nagarythe_faction = "wh2_main_hef_nagarythe";
local hef_culture = "wh2_main_hef_high_elves";
local block_hef_stance = true;
local no_block_faction ="";

local function stance_faction_is_high_elve(faction)
	if faction:is_null_interface() then
		return false;
	end

	local faction_subculture = faction:subculture();
	local is_elf = false;
	
	
	if faction_subculture ==  "wh2_main_sc_hef_high_elves" then
		out("shy: is elf!");
		is_elf = true;
	end
	
	
	if is_elf == true then
		return true;
	else
		return false;
	end
end

local function hide_underway_stance_hef()
	local button_parent = find_uicomponent(core:get_ui_root(), "hud_campaign", "BL_parent", "land_stance_button_stack", "clip_parent", "stack_background")

    if button_parent then
        local uic = find_uicomponent(button_parent, "button_MILITARY_FORCE_ACTIVE_STANCE_TYPE_TUNNELING");
        if uic then
			--out("shy:found button 1");
            --uic:SetVisible(false);
			uic:SetState("inactive");
			uic:SetTooltipText("你需要合邦纳迦瑞斯解锁这个状态", false);
        end
    end
	button_parent = find_uicomponent(core:get_ui_root(), "hud_campaign", "BL_parent", "land_stance_button_stack", "clip_parent", "stack_background")

    if button_parent then
        local uic = find_uicomponent(button_parent, "button_MILITARY_FORCE_ACTIVE_STANCE_TYPE_STALKING");
        if uic then
			--out("shy:found button 2");
            --uic:SetVisible(false);
			uic:SetState("inactive");
			uic:SetTooltipText("你需要合邦纳迦瑞斯解锁这个状态", true);
        end
    end
end

function wh2_main_hef_stances()	
	
	out("wh2_main_hef_stances start!");
	
	core:add_listener(
		"nagarythe_faction_joins_confederation",
		"FactionJoinsConfederation",
		function(context)
			local faction_name = context:faction():name();		
			out("shy:faction_name"..faction_name);
			return faction_name == hef_nagarythe_faction;
		end,
		function(context)
			local faction = context:confederation();
			no_block_faction = context:confederation():name();
			out("shy:no_block_faction"..no_block_faction);
			local faction_name_log = context:faction():name();
			out("shy:faction_name_log"..faction_name_log);
			block_hef_stance = false;
		end,
		true
	);	
	
	core:add_listener(
		"hide_hef_stance",
		"ComponentMouseOn",
		function(context)
			out("shy:move on button is "..context.string);
			return block_hef_stance == true ;
		end,
		function(context)
			local script_belongs_to = cm:get_local_faction_name(true);
			out("shy:script_belongs_to "..script_belongs_to);	
			local is_hef = stance_faction_is_high_elve(cm:model():world():faction_by_key(script_belongs_to));
			out("shy is hef faction is "..tostring(is_hef));
			if script_belongs_to and script_belongs_to ~= hef_nagarythe_faction and is_hef == true then
									
				local find_military_button = string.find(context.string,"button_MILITARY_FORCE_ACTIVE_STANCE_TYPE");
				out("shy:button is "..context.string);
				if find_military_button then
					out("shy:find it");
					hide_underway_stance_hef();				
				else	
					out("shy:not find!");
				end				
			end
		end,
		true
	);
	core:add_listener(
        "block_hef_stance_by_default",
        "ForceAdoptsStance",
        function(context)   
            
            return true;
        end,
        function(context)
            local mf = context:military_force();
            if mf then
				local faction_name = mf:faction():name();
				out("shy: find faction name is "..faction_name);
				out("shy: no_block_faction name is "..no_block_faction);
				local faction_culture = mf:faction():culture();
				out("shy: find faction culture is "..faction_culture);
				if faction_name ~= no_block_faction then
					if faction_name ~= hef_nagarythe_faction and faction_culture == hef_culture then 
						local char = mf:general_character()
						if not char:is_null_interface() then
							local cqi = char:command_queue_index();
							local char_str = cm:char_lookup_str(cqi);
							out("shy: find general is !"..char_str);						
							local mf_stance = mf:active_stance();
							out("shy: find stance is !"..mf_stance);
							if mf_stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_TUNNELING" or mf_stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_STALKING" then
								out("shy: excuse find stance is !"..mf_stance);
								cm:force_character_force_into_stance(char_str, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_DEFAULT");
							end
						end
					end
				end
            end
        end,
        true
    )
	out("wh2_main_hef_stances end!");
end


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("block_hef_stance", block_hef_stance, context);		
		cm:save_named_value("no_block_faction", no_block_faction, context);		
	end
);

cm:add_loading_game_callback(
	function(context)
		if (not cm:is_new_game()) then		
			block_hef_stance = cm:load_named_value("block_hef_stance", true, context);	
			no_block_faction = cm:load_named_value("no_block_faction", "", context);
		end
	end
);

