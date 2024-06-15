local imrik_faction = "";
local dragon_target_force_cqi = 0;
local dragon_target_cqi = 0;
local current_dilemma = "";
local imrik_faction_name = "wh2_dlc15_hef_imrik"

local dragon_turns_spawn_timer = 11;
local dragon_marker_cooldown = 15;
local dragon_marker_turns_available = 20;
local dragon_marker_turns = 20;
local position = {-1, -1};

local dragon_post_battle_listener = false;
local dragon_marker_key_counter = 1;
local dragon_mission_completed = 0;

local dragon_marker_state = {
	cooldown = 1,
	spawned = 2,
};

---variables to determine the rate at which AI Imrik's dragon merc pool refills
local ai_dragon_replen_chance = 0.01
local ai_dragon_cap = 1
local ai_dragon_max_replen = 1

local dragon_state = 1;

local incidents_list = {
    "wh2_dlc15_incident_dragon_encounter_generic_black",
	"wh2_dlc15_incident_dragon_encounter_generic_forest",
	"wh2_dlc15_incident_dragon_encounter_generic_star",
	"wh2_dlc15_incident_dragon_encounter_generic_sun",
	"wh2_dlc15_incident_dragon_encounter_generic_moon"
};		

local dragon_factions_list = {
	"wh2_main_def_dark_elves_qb3",
	"wh_dlc05_wef_wood_elves_qb1",
	"wh2_main_hef_high_elves_qb3",
	"wh2_main_hef_high_elves_qb2",
	"wh2_main_hef_high_elves_qb1"
};

local dragon_dilemma_list = {
	"wh2_dlc15_dilemma_dragon_encounter_generic_forest",
	"wh2_dlc15_dilemma_dragon_encounter_generic_black",
	"wh2_dlc15_dilemma_dragon_encounter_generic_moon",
	"wh2_dlc15_dilemma_dragon_encounter_generic_star",
	"wh2_dlc15_dilemma_dragon_encounter_generic_sun"
};

local dragon_dilemma_special_list = {
	"wh2_dlc15_dilemma_dragon_encounter_special_black",
	"wh2_dlc15_dilemma_dragon_encounter_special_forest",
	"wh2_dlc15_dilemma_dragon_encounter_special_moon",
	"wh2_dlc15_dilemma_dragon_encounter_special_star",
	"wh2_dlc15_dilemma_dragon_encounter_special_sun"
};

local dragon_dilemma_special_ready = {
	"wh2_dlc15_dilemma_dragon_encounter_special_black",
	"wh2_dlc15_dilemma_dragon_encounter_special_forest",
	"wh2_dlc15_dilemma_dragon_encounter_special_moon",
	"wh2_dlc15_dilemma_dragon_encounter_special_star",
	"wh2_dlc15_dilemma_dragon_encounter_special_sun"
};

local normal_details = {
	["wh2_dlc15_dilemma_dragon_encounter_generic_black"] = {"black_dragon_cult", dragon_factions_list[1]},
	["wh2_dlc15_dilemma_dragon_encounter_generic_forest"] = {"forest_dragon_cult", dragon_factions_list[2]},
	["wh2_dlc15_dilemma_dragon_encounter_generic_star"] = {"star_dragon_cult", dragon_factions_list[3]},
	["wh2_dlc15_dilemma_dragon_encounter_generic_sun"] = {"sun_dragon_cult", dragon_factions_list[4]},
	["wh2_dlc15_dilemma_dragon_encounter_generic_moon"] = {"moon_dragon_cult", dragon_factions_list[5]}
};

local unit_details = {
	["wh2_dlc15_dilemma_dragon_encounter_special_black"] = "wh2_dlc15_hef_mon_black_dragon_imrik",
	["wh2_dlc15_dilemma_dragon_encounter_special_forest"] = "wh2_dlc15_hef_mon_forest_dragon_imrik",
	["wh2_dlc15_dilemma_dragon_encounter_special_moon"] = "wh2_dlc15_hef_mon_moon_dragon_imrik",
	["wh2_dlc15_dilemma_dragon_encounter_special_star"] = "wh2_dlc15_hef_mon_star_dragon_imrik",
	["wh2_dlc15_dilemma_dragon_encounter_special_sun"] = "wh2_dlc15_hef_mon_sun_dragon_imrik",
	["wh2_dlc15_dilemma_dragon_encounter_generic_black"] = "wh2_main_def_mon_black_dragon",
	["wh2_dlc15_dilemma_dragon_encounter_generic_forest"] = "wh2_dlc15_hef_mon_forest_dragon_0",	
	["wh2_dlc15_dilemma_dragon_encounter_generic_moon"] = "wh2_main_hef_mon_moon_dragon",
	["wh2_dlc15_dilemma_dragon_encounter_generic_star"] = "wh2_main_hef_mon_star_dragon",
	["wh2_dlc15_dilemma_dragon_encounter_generic_sun"] = "wh2_main_hef_mon_sun_dragon"
};

local generic_army_effect = {
	"wh2_dlc15_bundle_beserk",
	"wh2_dlc15_bundle_rage",
	"wh2_dlc15_bundle_regeneration",
	"wh2_dlc15_bundle_rebirth",
	"wh2_dlc15_bundle_blood_frenzy",
	"wh2_dlc15_bundle_primal_rage"
};	

function add_dragon_encounters_listeners_hef()
	local imrik_interface = cm:get_faction(imrik_faction);
	
	

	out("#### Adding Dragon Encounters Listeners hef ####");
	
	-- Check to see if conditions(timer) is correct to spawn marker
	cm:add_faction_turn_start_listener_by_name(
		"Imrik_FactionTurnStart_hef",
		imrik_faction,
		function(context)
			-- If marker is on cooldown then countdown until 0, then at 0 spawn the dragon marker
			if dragon_state == dragon_marker_state.cooldown then
				dragon_turns_spawn_timer = dragon_turns_spawn_timer - 1;
				set_dragon_countdown_ui_hef(dragon_turns_spawn_timer);
				
				if dragon_turns_spawn_timer < 1 then
					local imrik = imrik_interface:faction_leader();
					local imrik_loc = {0, 0};
					
					if not imrik:is_null_interface() then
						imrik_loc = {imrik:logical_position_x(), imrik:logical_position_y()};
					end;
					
					local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_position(imrik_faction, imrik_loc[1], imrik_loc[2], false, 25);
					
					-- If Imrik is dead or a valid location cannot be found then just spawn marker from capital
					if pos_x == -1 then
						local region_key = "";
						
						if imrik_interface:has_home_region() then
							region_key = imrik_interface:home_region():name();
						else
							-- imrik is dead, the player has no regions, so just dump it in the first available region!
							region_key = cm:model():world():region_manager():region_list():item_at(0):name();
						end;
						
						pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(imrik_faction, region_key, false, false, 20);	
					end;
					
					if pos_x > 0 then
						local key = "dragon_marker_" .. tostring(dragon_marker_key_counter);
						
						-- setup marker and UI
						cm:add_interactable_campaign_marker(key, "dragon_marker", pos_x, pos_y, 2, imrik_faction, "");
						position = {pos_x, pos_y};
						
						local region_key_spawned_in = cm:model():world():region_data_at_position(pos_x, pos_y):key();
						
						cm:show_message_event_located(
							imrik_faction,
							"event_feed_strings_text_wh2_dlc15_event_feed_string_scripted_event_hef_dragon_encounter_spawned_title",
							"regions_onscreen_" .. region_key_spawned_in,
							"event_feed_strings_text_wh2_dlc15_event_feed_string_scripted_event_hef_dragon_encounter_spawned_secondary_detail",
							pos_x,
							pos_y,
							false,
							1132
						);
						
						-- Marker Entered
						setup_dragon_encounter_entered_listener_hef();
						
						-- Check if a special dragon dilemma is available and if so then trigger it
						if #dragon_dilemma_special_ready > 0 then
							local index = cm:random_number(#dragon_dilemma_special_ready); 
							current_dilemma = dragon_dilemma_special_ready[index];
						-- If there are no special dilemmas left then trigger a normal dilemma
						else
							local index = cm:random_number(#dragon_dilemma_list);
							current_dilemma = dragon_dilemma_list[index];
							core:trigger_event("ScriptEventImrikDragonEncounterGeneric");
						end
						
						set_dragon_marker_ui_hef(dragon_marker_turns_available, pos_x, pos_y)
						core:trigger_event("ScriptEventImrikDragonMarkerSpawn");
						
						dragon_turns_spawn_timer = dragon_marker_cooldown;
						dragon_state = dragon_marker_state.spawned;
					end;
				end;
			-- If marker is active then countdown until 0 then remove the marker	
			elseif dragon_state == dragon_marker_state.spawned then
				dragon_marker_turns_available = dragon_marker_turns_available - 1;
				common.set_context_value("dragon_taming_turns_current", dragon_marker_turns_available);
				
				if dragon_marker_turns_available == 0 then
					cm:remove_interactable_campaign_marker("dragon_marker_" .. tostring(dragon_marker_key_counter));
					common.set_context_value("dragon_taming_turns_until_next", dragon_turns_spawn_timer);
					dragon_marker_key_counter = dragon_marker_key_counter + 1;
					dragon_state = dragon_marker_state.cooldown;
					dragon_marker_turns_available = dragon_marker_turns;
				end;
			end;
		end,
		true
	);
	
	-- Dilemma Choice listener readded after saving/loading
	core:add_listener(
		"dragon_DilemmaChoiceMadeEvent_hef",
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma():starts_with("wh2_dlc15_dilemma_dragon_encounter_");
		end,
		function(context)
			local dilemma = context:dilemma();
			local choice = context:choice();
			
			for i = 1, #dragon_dilemma_list do
				-- If its a normal dilemma then spawn a special dragon army (similar to encounter at sea) for the player to fight against
				if dilemma == dragon_dilemma_list[i] and choice == 2 and normal_details[dilemma] then
					local x, y = cm:find_valid_spawn_location_for_character_from_position(imrik_faction, position[1], position[2], false);
					spawn_dragon_campaign_army_hef({x, y}, normal_details[dragon_dilemma_list[i]][1], normal_details[dragon_dilemma_list[i]][2], 15);
					
					break;
				-- If its a special dilemma then remove it from the special list table once the quest battle mission has been chosen, if its not quest battle choice then we want the dilemma to remain in the pool
				elseif dilemma == dragon_dilemma_special_list[i] then
					if context:choice() == 2 then
						local index = 0;
						
						for j = 1, #dragon_dilemma_special_ready do
							if current_dilemma == dragon_dilemma_special_ready[j] then
								index = j;
							end;
						end;
						
						if index > 0 then
							table.remove(dragon_dilemma_special_ready, index);
						end;
						
						core:trigger_event("ScriptEventImrikDragonBattleSpawn");
					else
						core:trigger_event("ScriptEventImrikDragonDilemmaNonBattle");
					end;
					
					break;
				end;
			end;
			
			cm:remove_interactable_campaign_marker("dragon_marker_" .. tostring(dragon_marker_key_counter));
			set_dragon_countdown_ui_hef(dragon_turns_spawn_timer);
			set_dragon_marker_ui_hef(0);
			
			dragon_marker_key_counter = dragon_marker_key_counter + 1;
			dragon_state = dragon_marker_state.cooldown;
			dragon_marker_turns_available = dragon_marker_turns;
		end,
		true
	);
	
	imrik_setup_dragon_armies_hef();

	-- Reconstructing listener, if there's marker activated
	if dragon_state == 2 then
		setup_dragon_encounter_entered_listener_hef();	
	end;
	
	-- Reconstructing Post battle listener
	if dragon_post_battle_listener then
		setup_dragon_post_battle_listener_hef();
	end;
	
	-- Reconstructing the UI for the dragon marker depending on what state it is in
	if dragon_state == dragon_marker_state.cooldown then
		set_dragon_countdown_ui_hef(dragon_turns_spawn_timer);
	elseif dragon_state == dragon_marker_state.spawned then
		set_dragon_marker_ui_hef(dragon_marker_turns_available, position[1], position[2]);
	end;
	
	core:add_listener(
		"DragonMissionSucceeded_hef",
		"MissionSucceeded",
		function(context)
			return context:faction():name() == imrik_faction;
		end,
		function(context)
			local imrik_interface = context:faction();
			local mission_key = context:mission():mission_record_key();
			
			if mission_key == "wh2_dlc15_ME_hef_imrik_black_dragon_stage_1" then
				cm:add_unit_to_faction_mercenary_pool(imrik_interface, "wh2_dlc15_hef_mon_black_dragon_imrik", "renown", 1, 100, 1, 0.1, "", "", "", true, "wh2_dlc15_hef_mon_black_dragon_imrik");
				dragon_mission_completed = dragon_mission_completed + 1;
			elseif mission_key == "wh2_dlc15_ME_hef_imrik_forest_dragon_stage_1" then
				cm:add_unit_to_faction_mercenary_pool(imrik_interface, "wh2_dlc15_hef_mon_forest_dragon_imrik", "renown", 1, 100, 1, 0.1, "", "", "", true, "wh2_dlc15_hef_mon_forest_dragon_imrik");
				dragon_mission_completed = dragon_mission_completed + 1;
			elseif mission_key == "wh2_dlc15_ME_hef_imrik_moon_dragon_stage_1" then
				cm:add_unit_to_faction_mercenary_pool(imrik_interface, "wh2_dlc15_hef_mon_moon_dragon_imrik", "renown", 1, 100, 1, 0.1, "", "", "", true, "wh2_dlc15_hef_mon_moon_dragon_imrik");
				dragon_mission_completed = dragon_mission_completed + 1;
			elseif mission_key == "wh2_dlc15_ME_hef_imrik_star_dragon_stage_1" then
				cm:add_unit_to_faction_mercenary_pool(imrik_interface, "wh2_dlc15_hef_mon_star_dragon_imrik", "renown", 1, 100, 1, 0.1, "", "", "", true, "wh2_dlc15_hef_mon_star_dragon_imrik");
				dragon_mission_completed = dragon_mission_completed + 1;
			elseif mission_key == "wh2_dlc15_ME_hef_imrik_sun_dragon_stage_1" then
				cm:add_unit_to_faction_mercenary_pool(imrik_interface, "wh2_dlc15_hef_mon_sun_dragon_imrik", "renown", 1, 100, 1, 0.1, "", "", "", true, "wh2_dlc15_hef_mon_sun_dragon_imrik");
				dragon_mission_completed = dragon_mission_completed + 1;
			end;
			
			-- Check how many missions completed and then trigger specific dilemmas
			if dragon_mission_completed == 1 then
				core:trigger_event("ScriptEventImrikDragonBattleWinOne");
			elseif dragon_mission_completed == 2 then
				core:trigger_event("ScriptEventImrikDragonBattleWinTwo");
			elseif dragon_mission_completed == 5 then
				core:trigger_event("ScriptEventImrikDragonBattleWinFive");
			end;
		end,
		true
	);
end;

-- Set the values of the dragon-encounter marker. For cases where the local faction is not Imrik's faction, this function does nothing.
function set_dragon_marker_ui_hef(turns_available, marker_x, marker_y)
	if cm:get_local_faction_name(true) == imrik_faction then
		common.set_context_value("dragon_taming_turns_current", turns_available);
		if marker_x ~= nil then
			find_uicomponent(core:get_ui_root(), "dragon_taming_icon", "icon"):InterfaceFunction("SetMarkerData", unit_details[current_dilemma], marker_x, marker_y);
		end;
	end;
end;

-- Set the timer counting down until the next dragon encounter spawns.
function set_dragon_countdown_ui_hef(dragon_spawn_timer)
	if cm:get_local_faction_name(true) == imrik_faction then
		common.set_context_value("dragon_taming_turns_until_next", dragon_spawn_timer);
	end;
end;

-- Spawn generic dragon army to fight the player when they encounter a normal dilemma and choose the encounter option
function spawn_dragon_campaign_army_hef(loc, force, faction_drag, size)
	local unit_list = random_army_manager:generate_force(force, size);
	local index = cm:random_number(#generic_army_effect);
	local army_dragon = invasion_manager:new_invasion("dragon_army", faction_drag, unit_list, loc);
	army_dragon.target = imrik_faction;
	army_dragon.human = false;
	army_dragon:apply_effect(generic_army_effect[index], 0);
	
	army_dragon:start_invasion(
		function(self)
			force_leader = self:get_general();
			cm:scroll_camera_from_current(false, 6, {force_leader:display_position_x(), force_leader:display_position_y(), 14.768, 0.0, 12.0});
			core:add_listener(
				"Dragon_army_engage_hef",
				"FactionLeaderDeclaresWar",
				true,
				function(context)
					if faction_drag == context:character():faction():name() then
						cm:set_force_has_retreated_this_turn(cm:get_military_force_by_cqi(dragon_target_force_cqi));
						cm:force_attack_of_opportunity(force_leader:military_force():command_queue_index(), dragon_target_force_cqi, false);
					end;
				end,
				false
			);
			
			cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
			cm:disable_event_feed_events(true, "wh_event_category_character", "", "");
			
			cm:force_declare_war(faction_drag, imrik_faction, false, false, false);
		end,
		false,
		false,
		false
	);
	
	setup_dragon_post_battle_listener_hef();
end;

-- Post battle listeners for to remove the generic spawned army from the campaign and reward the player should they win
function setup_dragon_post_battle_listener_hef()
	core:add_listener(
		"DragonPostbattle_hef",
		"BattleCompleted", 
		true,
		function()
			local found_encounter_faction_indx = 0;
			
			if cm:pending_battle_cache_num_attackers() >= 1 then
				for i = 1, cm:pending_battle_cache_num_attackers() do
					local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
					
					for j = 1, #dragon_factions_list do
						if current_faction_name == dragon_factions_list[j]  then
							found_encounter_faction_indx = j;
							break;
						end;
					end;
				end;
			end;
			
			if cm:pending_battle_cache_num_defenders() >= 1 then
				for i = 1, cm:pending_battle_cache_num_defenders() do
					local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
					
					for j = 1, #dragon_factions_list do
						if current_faction_name == dragon_factions_list[j]  then
							found_encounter_faction_indx = j;
							break;
						end;
					end;
				end;
			end;
			
			local dragon_invasion = invasion_manager:get_invasion("dragon_army");
			
			if found_encounter_faction_indx and dragon_invasion then
				dragon_invasion:kill();
			end;
			
			if cm:pending_battle_cache_defender_victory() and found_encounter_faction_indx ~= 0 then
				cm:trigger_incident(imrik_faction, incidents_list[found_encounter_faction_indx], true);
			end;
			
			cm:callback(
				function()
					cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "");
					cm:disable_event_feed_events(false, "wh_event_category_character", "", "");
				end,
				1
			);
			
			dragon_post_battle_listener = false;
		end,
		false
	);
	
	dragon_post_battle_listener = true;
end;

function setup_dragon_encounter_entered_listener_hef()
	core:remove_listener("dragon_AreaEntered_hef");
	
	core:add_listener(
		"dragon_AreaEntered_hef",
		"AreaEntered",
		function(context)
			local character = context:family_member():character()
			return not character:is_null_interface() and character:faction():name() == imrik_faction and context:area_key() == "dragon_marker_" .. tostring(dragon_marker_key_counter) and cm:char_is_general_with_army(character);
		end,
		function(context)
			local character = context:family_member():character();
			
			cm:trigger_dilemma(character:faction():name(), current_dilemma);
			dragon_target_force_cqi = character:military_force():command_queue_index();
			dragon_target_cqi = character:command_queue_index();
			core:trigger_event("ScriptEventImrikDragonMarkerEnter");
		end,
		true
	);
end;

-- Dragon armies spawned for normal dilemmas
function imrik_setup_dragon_armies_hef()
	--Forest Dragon
	random_army_manager:new_force("forest_dragon_cult");
	random_army_manager:add_mandatory_unit("forest_dragon_cult", "wh2_dlc15_hef_mon_forest_dragon_0", 1);
	random_army_manager:add_mandatory_unit("forest_dragon_cult", "wh_dlc05_wef_mon_great_eagle_0", 2);
	random_army_manager:add_mandatory_unit("forest_dragon_cult", "wh_dlc05_wef_inf_eternal_guard_0", 2);
	random_army_manager:add_mandatory_unit("forest_dragon_cult", "wh_dlc05_wef_inf_eternal_guard_1", 2);
	random_army_manager:add_mandatory_unit("forest_dragon_cult", "wh_dlc05_wef_inf_dryads_0", 2);
	random_army_manager:add_unit("forest_dragon_cult", "wh_dlc05_wef_mon_treeman_0", 1);
	random_army_manager:add_unit("forest_dragon_cult", "wh_dlc05_wef_mon_treekin_0", 2);
	random_army_manager:add_unit("forest_dragon_cult", "wh_dlc05_wef_cav_glade_riders_0", 2);
	random_army_manager:add_unit("forest_dragon_cult", "wh_dlc05_wef_inf_glade_guard_0", 2);
	random_army_manager:add_unit("forest_dragon_cult", "wh_dlc05_wef_inf_deepwood_scouts_0", 2);
	random_army_manager:add_unit("forest_dragon_cult", "wh_dlc05_wef_cav_wild_riders_0", 1);
	random_army_manager:add_unit("forest_dragon_cult", "wh_dlc05_wef_cav_sisters_thorn_0", 1);
	random_army_manager:add_unit("forest_dragon_cult", "wh_dlc05_wef_cav_hawk_riders_0", 1);
	--Black Dragon
	random_army_manager:new_force("black_dragon_cult");
	random_army_manager:add_mandatory_unit("black_dragon_cult", "wh2_main_def_mon_black_dragon", 1);
	random_army_manager:add_mandatory_unit("black_dragon_cult", "wh2_main_def_inf_harpies", 2);
	random_army_manager:add_mandatory_unit("black_dragon_cult", "wh2_main_def_inf_bleakswords_0", 2);
	random_army_manager:add_mandatory_unit("black_dragon_cult", "wh2_main_def_inf_dreadspears_0", 2);
	random_army_manager:add_mandatory_unit("black_dragon_cult", "wh2_main_def_inf_darkshards_0", 2);
	random_army_manager:add_unit("black_dragon_cult", "wh2_main_def_mon_war_hydra", 2);
	random_army_manager:add_unit("black_dragon_cult", "wh2_main_def_inf_shades_2", 2);
	random_army_manager:add_unit("black_dragon_cult", "wh2_main_def_cav_cold_one_knights_0", 2);
	random_army_manager:add_unit("black_dragon_cult", "wh2_main_def_cav_dark_riders_0", 2);
	random_army_manager:add_unit("black_dragon_cult", "wh2_dlc14_def_cav_scourgerunner_chariot_0", 2);
	random_army_manager:add_unit("black_dragon_cult", "wh2_main_def_art_reaper_bolt_thrower", 2);
	random_army_manager:add_unit("black_dragon_cult", "wh2_dlc14_def_mon_bloodwrack_medusa_0", 2);
	random_army_manager:add_unit("black_dragon_cult", "wh2_dlc10_def_mon_feral_manticore_0", 2);
	--Sun Dragon
	random_army_manager:new_force("sun_dragon_cult");
	random_army_manager:add_mandatory_unit("sun_dragon_cult", "wh2_main_hef_mon_sun_dragon", 1);
	random_army_manager:add_mandatory_unit("sun_dragon_cult", "wh2_main_hef_inf_spearmen_0", 2);
	random_army_manager:add_mandatory_unit("sun_dragon_cult", "wh2_main_hef_inf_lothern_sea_guard_0", 2);
	random_army_manager:add_mandatory_unit("sun_dragon_cult", "wh2_main_hef_inf_lothern_sea_guard_1", 2);
	random_army_manager:add_mandatory_unit("sun_dragon_cult", "wh2_main_hef_inf_archers_1", 2);
	random_army_manager:add_unit("sun_dragon_cult", "wh2_dlc15_hef_mon_arcane_phoenix_0", 1);
	random_army_manager:add_unit("sun_dragon_cult", "wh2_main_hef_cav_silver_helms_0", 2);
	random_army_manager:add_unit("sun_dragon_cult", "wh2_main_hef_cav_ellyrian_reavers_1", 2);
	random_army_manager:add_unit("sun_dragon_cult", "wh2_main_hef_cav_dragon_princes", 2);
	random_army_manager:add_unit("sun_dragon_cult", "wh2_main_hef_cav_tiranoc_chariot", 2);
	random_army_manager:add_unit("sun_dragon_cult", "wh2_main_hef_mon_phoenix_flamespyre", 1);
	random_army_manager:add_unit("sun_dragon_cult", "wh2_main_hef_mon_phoenix_frostheart", 1);
	random_army_manager:add_unit("sun_dragon_cult", "wh2_main_hef_art_eagle_claw_bolt_thrower", 1);
	--Moon Dragon
	random_army_manager:new_force("moon_dragon_cult");
	random_army_manager:add_mandatory_unit("moon_dragon_cult", "wh2_main_hef_mon_moon_dragon", 1);
	random_army_manager:add_mandatory_unit("moon_dragon_cult", "wh2_main_hef_inf_spearmen_0", 2);
	random_army_manager:add_mandatory_unit("moon_dragon_cult", "wh2_main_hef_inf_lothern_sea_guard_0", 2);
	random_army_manager:add_mandatory_unit("moon_dragon_cult", "wh2_main_hef_inf_lothern_sea_guard_1", 2);
	random_army_manager:add_mandatory_unit("moon_dragon_cult", "wh2_main_hef_inf_archers_1", 4);
	random_army_manager:add_unit("moon_dragon_cult", "wh2_dlc15_hef_mon_arcane_phoenix_0", 1);
	random_army_manager:add_unit("moon_dragon_cult", "wh2_main_hef_cav_silver_helms_0", 2);
	random_army_manager:add_unit("moon_dragon_cult", "wh2_main_hef_cav_ellyrian_reavers_1", 2);
	random_army_manager:add_unit("moon_dragon_cult", "wh2_main_hef_cav_dragon_princes", 2);
	random_army_manager:add_unit("moon_dragon_cult", "wh2_main_hef_cav_tiranoc_chariot", 2);
	random_army_manager:add_unit("moon_dragon_cult", "wh2_main_hef_mon_phoenix_flamespyre", 1);
	random_army_manager:add_unit("moon_dragon_cult", "wh2_main_hef_mon_phoenix_frostheart", 1);
	random_army_manager:add_unit("moon_dragon_cult", "wh2_main_hef_art_eagle_claw_bolt_thrower", 1);
	--Star Dragon
	random_army_manager:new_force("star_dragon_cult");
	random_army_manager:add_mandatory_unit("star_dragon_cult", "wh2_main_hef_mon_star_dragon", 1);
	random_army_manager:add_mandatory_unit("star_dragon_cult", "wh2_main_hef_inf_spearmen_0", 2);
	random_army_manager:add_mandatory_unit("star_dragon_cult", "wh2_main_hef_inf_lothern_sea_guard_0", 2);
	random_army_manager:add_mandatory_unit("star_dragon_cult", "wh2_main_hef_inf_lothern_sea_guard_1", 2);
	random_army_manager:add_mandatory_unit("star_dragon_cult", "wh2_main_hef_inf_archers_1", 4);
	random_army_manager:add_unit("star_dragon_cult", "wh2_dlc15_hef_mon_arcane_phoenix_0", 1);
	random_army_manager:add_unit("star_dragon_cult", "wh2_main_hef_cav_silver_helms_0", 2);
	random_army_manager:add_unit("star_dragon_cult", "wh2_main_hef_cav_ellyrian_reavers_1", 2);
	random_army_manager:add_unit("star_dragon_cult", "wh2_main_hef_cav_dragon_princes", 2);
	random_army_manager:add_unit("star_dragon_cult", "wh2_main_hef_cav_tiranoc_chariot", 2);
	random_army_manager:add_unit("star_dragon_cult", "wh2_main_hef_mon_phoenix_flamespyre", 1);
	random_army_manager:add_unit("star_dragon_cult", "wh2_main_hef_mon_phoenix_frostheart", 1);
	random_army_manager:add_unit("star_dragon_cult", "wh2_main_hef_art_eagle_claw_bolt_thrower", 1);
end;
--add

local function show_dragon_taming_ui()
		
	local ui_root = core:get_ui_root();	
	out("shy show_dragon_taming_ui print:");
	local ui_sotek = find_uicomponent(ui_root,"hud_campaign","dragon_taming_holder");
--	local ui_sotek = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar", "dragon_taming_holder");
	out("shy show_dragon_taming_ui print:dragon_taming_icon");
	if not ui_sotek then
	out("shy ERROR: dragon_taming_icon button find failed!");	
		return false;	
	end;	
	ui_sotek:SetVisible(true);	
end
function wh2_dlc15_dragon_encounters_hef()
	local local_faction = cm:get_local_faction_name(true);		
	out("wh2_dlc15_dragon_encounters_hef:local_faction "..local_faction);
	local script_belongs_faction = cm:model():world():faction_by_key(local_faction);
    
	
	if imrik_faction ~= "" and script_belongs_faction:culture() ==  "wh2_main_hef_high_elves" and local_faction == imrik_faction then		
		show_dragon_taming_ui();
		add_dragon_encounters_listeners_hef();			
	end

	core:add_listener(
		"confederation_imrik_faction",
		"FactionJoinsConfederation",
		function(context)
			local faction_name = context:faction():name();
			out("imrik:faction_name"..faction_name);
			return faction_name == imrik_faction_name;
		end,
		function(context)
			local faction = context:confederation();
			local confederation_name = context:confederation():name();
			out("imrik:confederation_name"..confederation_name);
			local faction_name_log = context:faction():name();
			out("imrik:faction_name_log"..faction_name_log);
			if faction:is_human() and imrik_faction == "" then		
                imrik_faction = confederation_name;
                dragon_turns_spawn_timer = dragon_turns_spawn_timer - 1;
				local imrik_interface = cm:get_faction(imrik_faction);
				for k, dragon in pairs(unit_details) do
					cm:add_unit_to_faction_mercenary_pool(imrik_interface, dragon, "renown", 0, ai_dragon_replen_chance, ai_dragon_cap, ai_dragon_max_replen, "", "", "", false, dragon);
				end
				show_dragon_taming_ui();
				add_dragon_encounters_listeners_hef();
			else
				out("imrik:fation is not hunman");
			end;
		end,
		true
	);
end
--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("imrik_faction_hef", imrik_faction, context);
		cm:save_named_value("dragon_state_hef", dragon_state, context);
		cm:save_named_value("current_dilemma_hef", current_dilemma, context);
		cm:save_named_value("dragon_turns_spawn_timer_hef", dragon_turns_spawn_timer, context);
		cm:save_named_value("dragon_marker_turns_available_hef", dragon_marker_turns_available, context);
		cm:save_named_value("dragon_marker_key_counter_hef", dragon_marker_key_counter, context);
		cm:save_named_value("dragon_post_battle_listener_hef", dragon_post_battle_listener, context);
		cm:save_named_value("unit_details_hef", unit_details, context);
		cm:save_named_value("position_hef", position, context);
		cm:save_named_value("dragon_dilemma_special_ready_hef", dragon_dilemma_special_ready, context);
		cm:save_named_value("dragon_mission_completed_hef", dragon_mission_completed, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			imrik_faction = cm:load_named_value("imrik_faction_hef", "", context);
			dragon_state = cm:load_named_value("dragon_state_hef", dragon_state, context);
			current_dilemma = cm:load_named_value("current_dilemma_hef", "", context);
			dragon_turns_spawn_timer = cm:load_named_value("dragon_turns_spawn_timer_hef", dragon_turns_spawn_timer, context);
			dragon_marker_turns_available = cm:load_named_value("dragon_marker_turns_available_hef", dragon_marker_turns_available, context);
			dragon_marker_key_counter = cm:load_named_value("dragon_marker_key_counter_hef", dragon_marker_key_counter, context);
			dragon_post_battle_listener = cm:load_named_value("dragon_post_battle_listener_hef", dragon_post_battle_listener, context);
			unit_details = cm:load_named_value("unit_details_hef", unit_details, context);
			position = cm:load_named_value("position_hef", position, context);
			dragon_dilemma_special_ready = cm:load_named_value("dragon_dilemma_special_ready_hef", dragon_dilemma_special_ready, context);
			dragon_mission_completed = cm:load_named_value("dragon_mission_completed_hef", dragon_mission_completed, context);
		end;
	end
);