local changing_of_the_way_faction = "wh3_dlc20_chs_vilitch";
local confiderate_changing_of_the_way_faction = "";

local chs_subculture = "wh_main_sc_chs_chaos";
local block_chs_stance = false;

function show_chs_changing_of_the_ways_ui(state)
	ui_show_group_management_button("button_changing_of_the_ways",state);
end
local function enable_chs_break_alliance(is_enable)
			
	if is_enable == true and confiderate_changing_of_the_way_faction ~= ""  then	
		local enable_faction = cm:model():world():faction_by_key(confiderate_changing_of_the_way_faction);
		if not enable_faction:has_effect_bundle("wh2_dlc20_enable_break_alliance") then							
			cm:apply_effect_bundle("wh2_dlc20_enable_break_alliance", confiderate_changing_of_the_way_faction, -1);								
		end;
			
	else
		local script_belongs_to = cm:get_local_faction_name(true);
		local enable_faction = cm:model():world():faction_by_key(script_belongs_to);
		if enable_faction:has_effect_bundle("wh2_dlc20_enable_break_alliance") then			
			cm:remove_effect_bundle("wh2_dlc20_enable_break_alliance", script_belongs_to);	
		end;
	end	
end


function chs_vilitch_faction_trait_set_faction(faction,local_faction)	
	if confiderate_changing_of_the_way_faction ~= "" then
       return;
    end;
	confiderate_changing_of_the_way_faction = faction;

	chs_eyes_of_god_table_add(faction,local_faction);
	chs_eyes_of_god_reinit();
	show_chs_changing_of_the_ways_ui(true);
	enable_chs_break_alliance(true);
	chs_enable_teleport_stance_feature(faction)
--	block_chs_stance = false;
end

function disable_all_chaos_tunnelling()   
    local faction_list = cm:model():world():faction_list();
	out("disable_all_chaos_tunnelling but "..tostring(changing_of_the_way_faction));	
	for i = 0, faction_list:num_items() - 1 do
		local faction = faction_list:item_at(i);
		local faction_name = faction:name();
        local faction_subculture = faction:subculture();
        out("disable_all_chaos_tunnelling:faction_name"..faction_name);
		if faction_subculture == chs_subculture then			
            if faction_name ~= changing_of_the_way_faction then			
                if faction_name ~= confiderate_changing_of_the_way_faction then
                     chs_disable_teleport_stance_feature(faction_name)                
                end;		
            end;	
        end;
	end;  
end


function wh3_dlc20_chs_vilitch_changing_of_the_ways()
	out("wh3_dlc20_chs_vilitch_changing_of_the_ways start");
--	wh2_main_chs_stances();
	disable_all_chaos_tunnelling()
	local_faction = cm:get_local_faction_name(true);		
	out("wh3_dlc20_chs_vilitch_changing_of_the_ways:local_faction "..local_faction);
	local script_belongs_faction = cm:model():world():faction_by_key(local_faction);   
	
	local chs_faction_name = confiderate_changing_of_the_way_faction;
	if script_belongs_faction:subculture() == chs_subculture then
		if chs_faction_name ~= "" and local_faction == chs_faction_name then		
			show_chs_changing_of_the_ways_ui(true);	
			enable_chs_break_alliance(true);
			chs_enable_teleport_stance_feature(local_faction)
		elseif chs_faction_name == "" and local_faction ~= changing_of_the_way_faction then
            show_chs_changing_of_the_ways_ui(false);
            
--			cm:faction_add_pooled_resource(local_faction, chs_nur_infections_key, nurgle_plagues_factor_key, -50);		
		end	
	end

end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("confiderate_changing_of_the_way_faction", confiderate_changing_of_the_way_faction, context)
        cm:save_named_value("block_chs_stance", block_chs_stance, context);		
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			confiderate_changing_of_the_way_faction = cm:load_named_value("confiderate_changing_of_the_way_faction", confiderate_changing_of_the_way_faction, context)	
			block_chs_stance = cm:load_named_value("block_chs_stance", true, context);	
		end
	end
)