

local nur_subculture = "wh3_main_sc_nur_nurgle";
local nur_nur_chieftains_faction = "";
local nur_nur_chieftains_owned_faction = "wh3_dlc25_nur_tamurkhan";


--Initialise the counters for the different plague types

cm:add_first_tick_callback(
	function()
		if nur_nur_chieftains_faction ~= "" then
			nur_chieftains.faction = nur_nur_chieftains_faction;
			nur_chieftains_remove_listeners();
		end
	end
);

local nur_tamurkhan_chieftain_unit_list = {
    ["wh3_dlc25_nur_other_chieftain_cav_chaos_chariot_mnur"] = "wh3_dlc25_nur_other_chieftain_cav_chaos_chariot_mnur",
    ["wh3_dlc25_nur_other_chieftain_inf_chaos_dwarf_blunderbusses"] = "wh3_dlc25_nur_other_chieftain_inf_chaos_dwarf_blunderbusses",
    ["wh3_dlc25_nur_other_chieftain_inf_infernal_guard_fireglaives"] = "wh3_dlc25_nur_other_chieftain_inf_infernal_guard_fireglaives",
    ["wh3_dlc25_nur_other_chieftain_mon_fimir_0"] = "wh3_dlc25_nur_other_chieftain_mon_fimir_0",
    ["wh3_dlc25_nur_other_chieftain_mon_ghorgon"] = "wh3_dlc25_nur_other_chieftain_mon_ghorgon",
    ["wh3_dlc25_nur_other_chieftain_mon_war_mammoth_0"] = "wh3_dlc25_nur_other_chieftain_mon_war_mammoth_0",
    ["wh3_dlc25_nur_other_chieftain_veh_dreadquake_mortar"] = "wh3_dlc25_nur_other_chieftain_veh_dreadquake_mortar",
    ["wh3_dlc25_nur_other_chieftain_inf_centigors_1"] = "wh3_dlc25_nur_other_chieftains_bst_inf_centigors_1",
    ["wh3_dlc25_nur_other_chieftain_inf_cygor_0"] = "wh3_dlc25_nur_other_chieftains_bst_inf_cygor_0",
    ["wh3_dlc25_nur_other_chieftain_art_hellcannon"] = "wh3_dlc25_nur_other_chieftains_chs_art_hellcannon",
    ["wh3_dlc25_nur_other_chieftain_inf_aspiring_champions_0"] = "wh3_dlc25_nur_other_chieftains_chs_inf_aspiring_champions_0",
    ["wh3_dlc25_nur_other_chieftain_mon_dragon_ogre_shaggoth"] = "wh3_dlc25_nur_other_chieftains_chs_mon_dragon_ogre_shaggoth",
    ["wh3_dlc25_nur_other_chieftain_mon_war_mammoth_1"] = "wh3_dlc25_nur_other_chieftains_def_mon_war_mammoth_0",
    ["wh3_dlc25_nur_other_chieftain_mon_fimir_1"] = "wh3_dlc25_nur_other_chieftains_nor_mon_fimir_1",
    ["wh3_dlc25_nur_other_chieftain_mon_frost_wyrm_0"] = "wh3_dlc25_nur_other_chieftains_nor_mon_frost_wyrm_0",
    ["wh3_dlc25_nur_other_chieftain_mon_skinwolves_0"] = "wh3_dlc25_nur_other_chieftains_nor_mon_skinwolves_0",
    ["wh3_dlc25_nur_other_chieftain_cav_rot_knights"] = "wh3_dlc25_nur_other_chieftains_nur_cav_rot_knights",
    ["wh3_dlc25_nur_other_chieftain_mon_toad_dragon"] = "wh3_dlc25_nur_other_chieftains_nur_mon_toad_dragon"
}
function nur_add_tamurkhan_chieftain_units()
      core:add_listener(
		"nur_chieftain_units_ritual",
		"RitualCompletedEvent",
		function(context)
			return context:performing_faction():name() == nur_nur_chieftains_faction;
		end,
		function(context)
			local faction = context:performing_faction();
			local faction_key = faction:name();
			local ritual = context:ritual():ritual_key();
			out("ritual name:"..ritual);
			
		end,
		true
	);
	for unit, group in pairs(nur_tamurkhan_chieftain_unit_list) do
        out(nur_nur_chieftains_faction.."--units:"..unit.."--group:"..group);	
        cm:add_unit_to_faction_mercenary_pool(
            cm:model():world():faction_by_key(nur_nur_chieftains_faction),
            unit,
            "tamurkhan_chieftains",
            0, -- unit count
            0, -- replenishment
            1, -- max_units
            0, -- max_units_replenished_per_turn
            "",
            "",
            "", -- restrictions
            true,
            group
        );
	end
end



function show_nur_chieftains_ui(state)
	ui_show_resources_bar_holder_name("nug_tamurkhan_chieftains_holder",state);
	ui_show_group_management_button("button_tamurkhan_chiefs",state);
end

function nur_chieftains_remove_listeners()
	core:remove_listener("IEVictoryConditionTamurkhanChieftainMissionListener");
	core:remove_listener("RoCVictoryConditionTamurkhanChieftainMissionListener");
	core:remove_listener("IEVictoryConditionShortVictoryMalakaiIronSteelBattles");

end

function wh3_dlc25_nur_chieftains_nur_set_faction(faction,local_faction)
    if nur_nur_chieftains_faction ~= "" then
       return;
    end;
	nur_nur_chieftains_faction = faction;
	nur_chieftains.faction = faction;
	
	nur_chieftains_remove_listeners();
	nur_add_tamurkhan_chieftain_units();
	out("wh3_dlc25_nur_chieftains_nur_set_faction:"..nur_nur_chieftains_faction)
--    faction_pool_resource_reinit(faction,emp_arcane_essays_key,emp_college_of_magic_factor_key)
	show_nur_chieftains_ui(true);
	
end





function wh3_dlc25_campaign_nur_chieftains_nur()
	out("wh3_dlc25_campaign_nur_chieftains_nur start");
	local_faction = cm:get_local_faction_name(true);		
	out("wh3_dlc25_campaign_nur_chieftains_nur:local_faction "..local_faction);
	local script_belongs_faction = cm:model():world():faction_by_key(local_faction);   
	
	local faction_name = nur_nur_chieftains_faction;
	if script_belongs_faction:subculture() == nur_subculture then
		if faction_name ~= "" and local_faction == faction_name then		
			show_nur_chieftains_ui(true);	
			nur_chieftains.faction = nur_nur_chieftains_faction;

		elseif faction_name == "" and local_faction ~= nur_nur_chieftains_owned_faction then

    
			show_nur_chieftains_ui(false);
						
		end	
	end
	
end


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("nur_nur_chieftains_faction", nur_nur_chieftains_faction, context)
--		cm:save_named_value("emp_wizard_cap", emp_wizard_cap, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			nur_nur_chieftains_faction = cm:load_named_value("nur_nur_chieftains_faction", nur_nur_chieftains_faction, context)		
--			emp_wizard_cap = cm:load_named_value("emp_wizard_cap", emp_wizard_cap, context)				
		end
	end
)