

local dwf_subculture = "wh2_main_hef_high_elves";
local dwf_malakai_battles_faction = "";
local emp_arcane_essays_key = "wh3_dlc25_emp_arcane_essays";
local dwf_malakai_battles_owned_faction = "wh3_dlc25_dwf_malakai";
local emp_college_of_magic_factor_key = "other";

cm:add_first_tick_callback(
	function()
		if dwf_malakai_battles_faction ~= "" then
			malakai_battles.malakai_faction = dwf_malakai_battles_faction;
			malakai_battles_remove_listeners();
		end
	end
);


local malakai_feature_unit_list = {
    ["wh_main_dwf_art_cannon_malakai"] = "wh3_dlc25_dwf_malakai_feature_cannons",
    ["wh_main_dwf_art_flame_cannon_malakai"] = "wh3_dlc25_dwf_malakai_feature_flame_cannons",
    ["wh3_dlc25_dwf_art_goblin_hewer_malakai"] = "wh3_dlc25_dwf_malakai_feature_goblin_hewer",
    ["wh_main_dwf_veh_gyrobomber_malakai"] = "wh3_dlc25_dwf_malakai_feature_gyrobomber",
    ["wh_main_dwf_veh_gyrocopter_0_malakai"] = "wh3_dlc25_dwf_malakai_feature_gyrocopter_0",
    ["wh_main_dwf_veh_gyrocopter_1_malakai"] = "wh3_dlc25_dwf_malakai_feature_gyrocopter_1",
    ["wh_main_dwf_art_organ_gun_malakai"] = "wh3_dlc25_dwf_malakai_feature_organ_guns",
    ["wh3_dlc25_dwf_veh_thunderbarge_malakai"] = "wh3_dlc25_dwf_malakai_feature_thunderbarge"   
}

function dwf_add_malakai_feature_units()
    for unit, group in pairs(malakai_feature_unit_list) do
		cm:add_unit_to_faction_mercenary_pool(
            cm:model():world():faction_by_key(dwf_malakai_battles_faction),
            unit,
            "renown",
            0, -- unit count
            0, -- replenishment
            3, -- max_units
            0, -- max_units_replenished_per_turn
            "",
            "",
            "", -- restrictions
            true,
            group
        );
		
	end

end

function show_malakai_battles_ui(state)
	ui_show_resources_bar_holder_name("dwf_malakai_adventures",state);
end

function malakai_battles_remove_listeners()
	core:remove_listener("IEVictoryConditionShortVictoryMalakaiIronSteelBattles");
	core:remove_listener("ROCVictoryConditionShortVictoryMalakaiIronSteelBattles");
	core:remove_listener("malakai_battles_ai_reward_unlocking");
end

function wh3_dlc25_malakai_battles_dwf_set_faction(faction,local_faction)
    if dwf_malakai_battles_faction ~= "" then
       return;
    end;
	dwf_malakai_battles_faction = faction;
	malakai_battles.malakai_faction = faction;
	malakai_battles:initialize();	
	malakai_battles_remove_listeners();
	dwf_add_malakai_feature_units();
	out("wh3_dlc25_malakai_battles_dwf_set_faction:"..dwf_malakai_battles_faction)
--    faction_pool_resource_reinit(faction,emp_arcane_essays_key,emp_college_of_magic_factor_key)
	show_malakai_battles_ui(true);
	
end





function wh3_dlc25_malakai_battles_dwf()
	out("wh3_dlc25_malakai_battles_dwf start");
	local_faction = cm:get_local_faction_name(true);		
	out("wh3_dlc25_malakai_battles_dwf:local_faction "..local_faction);
	local script_belongs_faction = cm:model():world():faction_by_key(local_faction);   
	
	local faction_name = dwf_malakai_battles_faction;
	if script_belongs_faction:subculture() == dwf_subculture then
		if faction_name ~= "" and local_faction == faction_name then		
			show_malakai_battles_ui(true);	
			malakai_battles.malakai_faction = dwf_malakai_battles_faction;
--			malakai_battles:initialize();
		elseif faction_name == "" and local_faction ~= dwf_malakai_battles_owned_faction then
            --faction_pool_resource_reinit(local_faction,emp_arcane_essays_key,emp_college_of_magic_factor_key);
    
			show_malakai_battles_ui(false);
			if cm:is_new_game() == true then
               -- cm:faction_add_pooled_resource(local_faction, emp_arcane_essays_key, emp_college_of_magic_factor_key, -150);
			end				
		end	
	end
	
end


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("dwf_malakai_battles_faction", dwf_malakai_battles_faction, context)
--		cm:save_named_value("emp_wizard_cap", emp_wizard_cap, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			dwf_malakai_battles_faction = cm:load_named_value("dwf_malakai_battles_faction", dwf_malakai_battles_faction, context)		
--			emp_wizard_cap = cm:load_named_value("emp_wizard_cap", emp_wizard_cap, context)				
		end
	end
)