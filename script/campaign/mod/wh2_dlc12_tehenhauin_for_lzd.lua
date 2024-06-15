cult_of_sotek_lzd = {
	faction_key = "",

	ritual_category_key = "SACRIFICE_RITUAL",
	prophecy_missions = {
		{
			-- prophecy 1 missions
			{complete = false, key = "wh2_dlc12_prophecy_of_sotek_1_1"},
			{complete = false, key = "wh2_dlc12_prophecy_of_sotek_1_2", reward_event = "ScriptEventSacrificeTier2Unlocked"},
			completion_event = "ScriptEventPoSStage1Completed"
		},
		{
			-- prophecy 2 missions
			{complete = false, key = "wh2_dlc12_prophecy_of_sotek_2_1"},
			{complete = false, key = "wh2_dlc12_prophecy_of_sotek_2_2"},
			{complete = false, key = "wh2_dlc12_prophecy_of_sotek_2_3", reward_event = "ScriptEventSacrificeTier3Unlocked"},
			{complete = false, key = "wh2_dlc12_prophecy_of_sotek_2_4", reward_event = "ScriptEventSacrificeTier4Unlocked"},
			completion_event = "ScriptEventPoSStage2Completed"
		},
		{
			-- prophecy 3 mission
			{complete = false, key = "wh2_dlc12_prophecy_of_sotek_3_1", reward_event = "ScriptEventSacrificeTier5Unlocked"}
		}
	},

	ritual_ancillary_types = {
		["wh2_dlc12_tehenhauin_sacrifice_of_quetza"] = "banner",
		["wh2_dlc12_tehenhauin_sacrifice_of_huanabic"] = "follower"
	},

	ancillary_list = {
		follower = {
			"wh2_main_anc_follower_lzd_architect",
			"wh2_main_anc_follower_lzd_astronomer",
			"wh2_dlc12_anc_follower_piqipoqi_qupacoco",
			"wh2_dlc12_anc_follower_chameleon_spotter",
			"wh2_dlc12_anc_follower_swamp_trawler_skink",
			"wh2_dlc12_anc_follower_prophets_spawn_brother",
			"wh2_dlc12_anc_follower_consul_of_calith",
			"wh2_dlc12_anc_follower_priest_of_the_star_chambers",
			"wh2_dlc12_anc_follower_lotl_botls_spawn_brother",
			"wh2_dlc12_anc_follower_obsinite_miner_skink"
		},
		
		banner = {
			"wh2_dlc12_anc_magic_standard_totem_of_the_spitting_viper",
			"wh2_dlc12_anc_magic_standard_coatlpelt_flagstaff", 
			"wh2_dlc12_anc_magic_standard_exalted_banner_of_xapati",
			"wh2_dlc12_anc_magic_standard_totem_pole_of_destiny",
			"wh2_main_anc_magic_standard_sun_standard_of_chotec",
			"wh2_main_anc_magic_standard_the_jaguar_standard",
			"wh2_dlc12_anc_magic_standard_culchan_feathered_standard",
			"wh2_dlc12_anc_magic_standard_flag_of_the_daystar",
			"wh2_dlc12_anc_magic_standard_shroud_of_chaqua",
			"wh2_dlc12_anc_magic_standard_sign_of_the_coiled_one"
		}
	},

	restricted_buildings_list = {
		"wh2_main_lzd_saurus_1",
		"wh2_main_lzd_saurus_2",
		"wh2_main_lzd_saurus_3"
	}
}

function cult_of_sotek_lzd:adjust_sacrificial_offerings(amount)
	cm:faction_add_pooled_resource(cult_of_sotek_lzd.faction_key, "lzd_sacrificial_offerings", "captured_in_battle", amount)
end


function cult_of_sotek_lzd:trigger_prophecy_completion_events()
	local faction = cult_of_sotek_lzd.faction_key;
	cm:callback(
		function()
			core:trigger_event("ScriptEventSacrificeTier2Unlocked", faction);
			end, 
			0.5
		);
	cm:callback(
		function()
			core:trigger_event("ScriptEventSacrificeTier3Unlocked", faction);
			end, 
			0.5
		);
	cm:callback(
		function()
			core:trigger_event("ScriptEventSacrificeTier4Unlocked", faction);
			end, 
			0.5
		);
	cm:callback(
		function()
			core:trigger_event("ScriptEventSacrificeTier5Unlocked", faction);
			end, 
			0.5
		);
	
end

local tehenhauin_faction = "wh2_dlc12_lzd_cult_of_sotek";

function cult_of_sotek_lzd:grant_ritual_ancillaries()
	core:add_listener(
		"sacrifice_ancillary_listener_lzd",
		"RitualCompletedEvent",
		function(context) 
			local ritual_key = context:ritual():ritual_key()
			local faction = context:performing_faction();
			if (cult_of_sotek_lzd.faction_key ~= "" and faction:name() ~= tehenhauin_faction and cult_of_sotek_lzd.ritual_ancillary_types[ritual_key])  then
				return true
			end

			return false
		end,
		function(context) 
			local ritual_key = context:ritual():ritual_key()
			local ancillaries = cult_of_sotek_lzd.ancillary_list[cult_of_sotek_lzd.ritual_ancillary_types[ritual_key]]
			local rand_anc = ancillaries[cm:random_number(#ancillaries, 1)]

			cm:add_ancillary_to_faction(context:performing_faction(), rand_anc, false) 
		end,
		true	
	)	
end



local function show_sotek_sacrifices_ui(state)
		
	local ui_root = core:get_ui_root();	
	out("shy print:");
	local ui_sotek = find_uicomponent(ui_root,"faction_buttons_docker", "button_group_management", "button_sotek_sacrifices");
	out("shy print:1");
	if not ui_sotek then
	out("shy ERROR: button find failed!");	
		return false;	
	end;			
	out("shy print:2");
	ui_sotek:SetVisible(state);		
end

function wh2_dlc12_tehenhauin_for_lzd()
	core:add_listener(
		"tehenhauin_faction_joins_confederation",
		"FactionJoinsConfederation",
		function(context)
			local faction_name = context:faction():name();		
			out("shy:sotek faction_name"..faction_name);
			return faction_name == tehenhauin_faction;
		end,
		function(context)
			local faction = context:confederation();
			local confederation_name = context:confederation():name();
			out("shy:sotek confederation_name"..confederation_name);
			local faction_name_log = context:faction():name();
			out("shy:sotek faction_name_log"..faction_name_log);
			if faction:is_human() and cult_of_sotek_lzd.faction_key == "" then
				cult_of_sotek_lzd.faction_key = confederation_name;
				out("shy:show_sotek_sacrifices_faction"..cult_of_sotek_lzd.faction_key);
				show_sotek_sacrifices_ui(true);	
				local tehenhauin = cm:get_faction(cult_of_sotek_lzd.faction_key);
				cm:unlock_rituals_in_category(tehenhauin, cult_of_sotek_lzd.ritual_category_key, -1);
				cult_of_sotek_lzd:trigger_prophecy_completion_events()
				cult_of_sotek_lzd:grant_ritual_ancillaries()					
			else	
				out("shy:fation is not hunman");
			end;
		end,
		true
	);
	out("#### Adding Tehenhauin Listeners lzd ####");
	if cult_of_sotek_lzd.faction_key ~= "" then
		local tehenhauin = cm:get_faction(cult_of_sotek_lzd.faction_key);
		if not tehenhauin then
			return
		end

		if tehenhauin:is_human() then
			show_sotek_sacrifices_ui(true);	
			cm:unlock_rituals_in_category(tehenhauin, cult_of_sotek_lzd.ritual_category_key, -1);
			cult_of_sotek_lzd:trigger_prophecy_completion_events();
	--		cult_of_sotek_lzd:declare_prophecy_listeners()
			cult_of_sotek_lzd:grant_ritual_ancillaries()	;					
		end	
	end  	
end
--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("SotekProphecies_faction_key", cult_of_sotek_lzd.faction_key, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		cult_of_sotek_lzd.faction_key = cm:load_named_value("SotekProphecies_faction_key", "", context)
	end
)