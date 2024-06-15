local belakor_faction_key = "";
local belakor_faction_name = "wh3_main_chs_shadow_legion";
local chs_subculture = "wh_main_sc_chs_chaos";

function show_chs_great_game_rituals_ui(state)
	ui_show_group_management_button("button_great_game_rituals",state);
	ui_show_resources_bar_holder_name("dae_ascendant_race_holder",state);
end

function chs_unlock_great_game_rituals()
	if belakor_faction_key == "" then
       return;
    end;
    out("chs_unlock_great_game_rituals start!");
	local ritual_key = {
		"wh3_main_ritual_belakor_gg_1",
		"wh3_main_ritual_belakor_gg_1_upgraded",
		"wh3_main_ritual_belakor_gg_1_uses",
		"wh3_main_ritual_belakor_gg_2",
		"wh3_main_ritual_belakor_gg_2_upgraded",
		"wh3_main_ritual_belakor_gg_2_uses",
		"wh3_main_ritual_belakor_gg_3",
		"wh3_main_ritual_belakor_gg_3_upgraded",
		"wh3_main_ritual_belakor_gg_3_uses",
		"wh3_main_ritual_belakor_gg_4",
		"wh3_main_ritual_belakor_gg_4_upgraded",
		"wh3_main_ritual_belakor_gg_4_uses"
	}
	for j = 1, #ritual_key do
         cm:unlock_ritual(cm:get_faction(belakor_faction_key), ritual_key[j]);       
    end
end

local function block_teleport_rift(state)
	local button_parent = find_uicomponent(core:get_ui_root(), "rifts", "rifts_panel", "options_list", "teleport_holder")

    if button_parent then       
			--out("shy:found button 1");
            --uic:SetVisible(false);
            out("block_teleport_rift find:"..button_parent:GetStateText())
            out("block_teleport_rift find tooltip:"..button_parent:GetTooltipText())
            button_parent:SetVisible(state);       
    else
        out("block_teleport_rift not find")
    end	
end

function chs_block_teleport_rift()	
	
	out("chs_block_teleport_rift start!");	
	if cm:get_campaign_name() ~= "main_warhammer" then
	   return;
    end  
    
    core:add_listener(
			"PanelOpenedCampaignteleport_rift",
			"PanelOpenedCampaign",
			function(context) 
                --out("chs_block_teleport_rift:open is "..context.string);
                --if context.string == "rifts" then
                --    print_all_uicomponent_children(core:get_ui_root());
				--end
				return context.string == "rifts";
			end,
			function(context)
				local script_belongs_to = cm:get_local_faction_name(true);
				out("chs_block_teleport_rift:script_belongs_to "..script_belongs_to);	
				local local_subculture = cm:model():world():faction_by_key(script_belongs_to):subculture();
				out("chs_block_teleport_rift is chs faction is "..local_subculture);
				if local_subculture == chs_subculture then
					if belakor_faction_key == "" then
						if script_belongs_to ~= belakor_faction_name then
							block_teleport_rift(false);
						end	
					else
						if script_belongs_to ~= belakor_faction_name then
                            if script_belongs_to ~= belakor_faction_key then                          
                                block_teleport_rift(false);
                            end						
						end	
					end								
				end		
			end,
			true
		)	
	
	out("chs_block_teleport_rift end!");
end


function chs_shadow_legion_faction_trait_set_faction(faction,local_faction)	
	if belakor_faction_key ~= "" then
       return;
    end;
	belakor_faction_key = faction;	
	show_chs_great_game_rituals_ui(true);	
--	chs_unlock_great_game_rituals();
	great_game_start_chs(belakor_faction_key);	
end



function wh3_dlc20_chs_shadow_legion_traits()
	out("wh3_dlc20_chs_shadow_legion_traits start");
	chs_block_teleport_rift();
	local_faction = cm:get_local_faction_name(true);		
	out("wh3_dlc20_chs_shadow_legion_traits:local_faction "..local_faction);
	local script_belongs_faction = cm:model():world():faction_by_key(local_faction);   
	
	local chs_faction_name = belakor_faction_key;
	if script_belongs_faction:subculture() == chs_subculture then
		if chs_faction_name ~= "" and local_faction == chs_faction_name then		
			show_chs_great_game_rituals_ui(true);	
--			chs_unlock_great_game_rituals();
			great_game_start_chs(belakor_faction_key);
--			set_great_game_rituals_faction(belakor_faction_key);
		elseif chs_faction_name == "" and local_faction ~= belakor_faction_name then
            show_chs_great_game_rituals_ui(false);
--			cm:faction_add_pooled_resource(local_faction, chs_nur_infections_key, nurgle_plagues_factor_key, -50);		
		end	
	end

end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("belakor_faction_key", belakor_faction_key, context)
--		cm:save_named_value("block_teleport_rift", block_teleport_rift, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			belakor_faction_key = cm:load_named_value("belakor_faction_key", belakor_faction_key, context)		
--			block_teleport_rift = cm:load_named_value("block_teleport_rift", block_teleport_rift, context)				
		end
	end
)