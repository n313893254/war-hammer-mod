local dust_faction = "";
local dust_faction_key = "wh2_main_skv_clan_eshin";
local dust_actions = {};
local dust_per_turn = 1;
local dust_cap = 1;
local dust_cooldown = 0;
local dust_cooldown_reset = 5;
local dust_xp_gain = 1200;
local dust_default_composite_scene = "global_action_generic";
local dust_composite_scene_overrides = {
	["REGION"] = {
		["wh2_dlc14_eshin_actions_sabotage"] = "global_action_sabotage",
		["wh2_dlc14_eshin_actions_great_fire"] = "global_action_great_fire",
		["wh2_dlc14_eshin_actions_sewer_pestilence"] = "global_action_sewer_pestilence"
	},
	["MILITARY_FORCE"] = {
		["wh2_dlc14_eshin_actions_fleet_bombing"] = "global_action_fleet_bombing"
	}
};
local dust_cutscene_actions = {
	["wh2_dlc14_eshin_actions_decapitation"] = true,
	["wh2_dlc14_eshin_actions_great_fire"] = true,
	["wh2_dlc14_eshin_actions_sewer_pestilence"] = true,
	["wh2_dlc14_eshin_actions_fleet_bombing"] = true
};
local dust_ai_values = {
	cooldown = 20,
	cooldown_min = 20,
	cooldown_max = 30,
	actions = {
		{key = "ambush",		weight = 10,	target = "ARMY",		cooldown_reset = 20,	cooldown = 0,	max_times = -1},
		{key = "assassinate",	weight = 10,	target = "CHARACTER",	cooldown_reset = 50,	cooldown = 0,	max_times = -1},
		{key = "sabotage",		weight = 10,	target = "REGION",		cooldown_reset = 50,	cooldown = 0,	max_times = -1},
		{key = "fleet_bombing",	weight = 1,		target = "NAVY",		cooldown_reset = 90,	cooldown = 0,	max_times = 1},
		{key = "great_fire",	weight = 1,		target = "CAPITAL",		cooldown_reset = 90,	cooldown = 0,	max_times = 1},
		{key = "sewer_plague",	weight = 1,		target = "CAPITAL",		cooldown_reset = 90,	cooldown = 0,	max_times = 1},
		{key = "decapitation",	weight = 1,		target = "FACTION",		cooldown_reset = 90,	cooldown = 0,	max_times = 1}
	}
};
local dust_action_to_event_pic = {
	["default"] = 790,
	["fleet_bombing"] = 791,
	["great_fire"] = 792,
	["sewer_plague"] = 793,
	["decapitation"] = 794
};

function add_shadowy_dealings_listeners_skv()
	out("#### Adding Shadowy Dealings Listeners skv ####");
	core:add_listener(
		"dust_FactionTurnStart_skv",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == dust_faction;
		end,
		function(context)
			dust_FactionTurnStart_skv(context:faction());
		end,
		true
	);
	core:add_listener(
		"dust_RitualCompletedEvent_skv",
		"RitualCompletedEvent",
		function(context)
			return context:performing_faction():name() == dust_faction;
		end,
		function(context)
			dust_RitualCompletedEvent_skv(context);
		end,
		true
	);
	core:add_listener(
		"dust_RitualsCompletedAndDelayedEvent_skv",
		"RitualsCompletedAndDelayedEvent",
		true,
		function(context)
			dust_RitualsCompletedAndDelayedEvent_skv(context);
		end,
		true
	);

	if is_new_game_skv() == true then
		dust_UpdateCap_skv();
--		dust_ai_values.cooldown = cm:random_number(dust_ai_values.cooldown_max, dust_ai_values.cooldown_min);
	end
	dust_UpdateUI_skv();
end

function dust_FactionTurnStart_skv(faction)
	if faction:pooled_resource_manager():resource("skv_dust"):is_null_interface() == false then
		if faction:is_human() == true then
			local dust = faction:pooled_resource_manager():resource("skv_dust");
			local dust_value = dust:value();
			local dust_max = dust:maximum_value();
			
			if dust_value == dust_max then
				dust_cooldown = 0;
			else
				if dust_cooldown == 0 then
					dust_cooldown = dust_cooldown_reset;
				end
				dust_cooldown = dust_cooldown - 1;
				
				if dust_cooldown == 0 then
					cm:faction_add_pooled_resource(dust_faction, "skv_dust", "wh2_dlc14_resource_factor_dust_per_turn", dust_per_turn);

					if (dust_value + dust_per_turn) < dust_max then
						dust_cooldown = dust_cooldown_reset;
					end
				end
			end

			for i = 1, #dust_actions do
				local comp_scene = dust_actions[i];
				cm:remove_scripted_composite_scene(comp_scene);
			end
			dust_actions = {};

			dust_UpdateUI_skv();
		else
--			dust_AI_Turn(faction);
		end
	end
end

function dust_RitualsCompletedAndDelayedEvent_skv(context)
	local ritual_list = context:rituals();

	for i = 0, ritual_list:num_items() - 1 do
		local ritual = ritual_list:item_at(i);
		local ritual_key = ritual:ritual_key();
		local ritual_category = ritual:ritual_category();

		if ritual_category == "ESHIN_RITUAL_DELAYED" then
			local faction = ritual:characters_who_performed():item_at(0):character():faction(); -- This is horrific
			local ritual_target = ritual:ritual_target();
			local target_type = ritual_target:target_type();
			local scene_type = dust_default_composite_scene;
			
			if dust_composite_scene_overrides[target_type] ~= nil and dust_composite_scene_overrides[target_type][ritual_key] ~= nil then
				scene_type = dust_composite_scene_overrides[target_type][ritual_key];
			end

			if target_type == "FACTION" then
				-- FACTION
				local target_faction = ritual_target:get_target_faction();

				if target_faction:is_null_interface() == false and target_faction:is_dead() == false then
					if target_faction:has_home_region() == true then
						local region = target_faction:home_region();
						local region_key = region:name();
						local settlement = region:settlement();
						local settlement_key = "settlement:"..region_key;
						local comp_scene = "dust_"..region_key;
						local scene_type = dust_default_composite_scene;
						local log_x = settlement:logical_position_x();
						local log_y = settlement:logical_position_y();
						local dis_x = settlement:display_position_x();
						local dis_y = settlement:display_position_y();
						
						if dust_composite_scene_overrides[target_type] ~= nil and dust_composite_scene_overrides[target_type][ritual_key] ~= nil then
							scene_type = dust_composite_scene_overrides[target_type][ritual_key];
						end
						
						dist_ShowCutscene_skv(comp_scene, faction, ritual, scene_type, log_x, log_y, dis_x, dis_y, region);
						table.insert(dust_actions, comp_scene);
					end
				end
			elseif target_type == "REGION" then
				-- REGION
				local target_region = ritual_target:get_target_region();
				
				if target_region:is_null_interface() == false then
					local region_key = target_region:name();
					local settlement = target_region:settlement();
					local settlement_key = "settlement:"..region_key;
					local comp_scene = "dust_"..region_key;
					local scene_type = dust_default_composite_scene;
					local log_x = settlement:logical_position_x();
					local log_y = settlement:logical_position_y();
					local dis_x = settlement:display_position_x();
					local dis_y = settlement:display_position_y();
					
					if dust_composite_scene_overrides[target_type] ~= nil and dust_composite_scene_overrides[target_type][ritual_key] ~= nil then
						scene_type = dust_composite_scene_overrides[target_type][ritual_key];
					end
					
					dist_ShowCutscene_skv(comp_scene, faction, ritual, scene_type, log_x, log_y, dis_x, dis_y, target_region);
					table.insert(dust_actions, comp_scene);
				end
			elseif target_type == "MILITARY_FORCE" then
				-- FORCE
				local target_force = ritual_target:get_target_force();

				if target_force:is_null_interface() == false and target_force:has_general() == true then
					local general = target_force:general_character();
					local cqi = general:command_queue_index();
					local comp_scene = "dust_"..cqi;
					local scene_type = dust_default_composite_scene;
					local log_x = general:logical_position_x();
					local log_y = general:logical_position_y();
					local dis_x = general:display_position_x();
					local dis_y = general:display_position_y();
						
					if dust_composite_scene_overrides[target_type] ~= nil and dust_composite_scene_overrides[target_type][ritual_key] ~= nil then
						scene_type = dust_composite_scene_overrides[target_type][ritual_key];
					end
					
					dist_ShowCutscene_skv(comp_scene, faction, ritual, scene_type, log_x, log_y, dis_x, dis_y, nil);
					table.insert(dust_actions, comp_scene);
				end
			end
		end
	end
end

function dust_RitualCompletedEvent_skv(context)
	local ritual = context:ritual();
	local ritual_key = ritual:ritual_key();
	local ritual_category = ritual:ritual_category();

	if ritual_category == "ESHIN_VORTEX_RITUAL" then
		core:trigger_event("ScriptEventShadowyDealingsEGMission");
		if ritual_key == "wh2_dlc14_eshin_actions_mortal_empires_mission_1" then
			dust_cap = dust_cap + 1;
			dust_UpdateCap_skv();
		elseif ritual_key == "wh2_dlc14_eshin_actions_mortal_empires_mission_2" then
			dust_cap = dust_cap + 1;
			dust_UpdateCap_skv();
		elseif ritual_key == "wh2_dlc14_eshin_actions_mortal_empires_mission_3" then
			dust_cap = dust_cap + 1;
			dust_UpdateCap_skv();
		elseif ritual_key == "wh2_dlc14_eshin_actions_mortal_empires_mission_4" then
			dust_cap = dust_cap + 1;
			dust_UpdateCap_skv();		
		end
	elseif ritual_category == "ESHIN_RITUAL" or ritual_category == "ESHIN_RITUAL_DELAYED" then
		core:trigger_event("ScriptEventShadowyDealingsEGMission");
		local faction = context:performing_faction();
		local ritual_target = ritual:ritual_target();

		if ritual_key == "wh2_dlc14_eshin_actions_steal_technology" then
			cm:apply_effect_bundle("wh2_dlc14_payload_eshin_actions_steal_technology", dust_faction, 5);
		end

		if ritual_key == "wh2_dlc14_eshin_actions_steal_ancillary" then
			cm:trigger_incident(dust_faction, "wh2_dlc14_incident_skv_eshin_actions_steal_ancillary", true);
		end

		if ritual_category == "ESHIN_RITUAL" then
			local target_type = ritual_target:target_type();

			if target_type == "FACTION" then
				-- FACTION
				local target_faction = ritual_target:get_target_faction();

				if target_faction:is_null_interface() == false and target_faction:is_dead() == false then
					if target_faction:has_home_region() == true then
						local region = target_faction:home_region();
						local region_key = region:name();
						local comp_scene = "dust_"..region_key;
						local scene_type = dust_default_composite_scene;
						
						if dust_composite_scene_overrides[target_type] ~= nil and dust_composite_scene_overrides[target_type][ritual_key] ~= nil then
							scene_type = dust_composite_scene_overrides[target_type][ritual_key];
						end
						
						cm:add_scripted_composite_scene_to_settlement(comp_scene, scene_type, region, 0, 0, true, true, false);
						table.insert(dust_actions, comp_scene);
					end
				end
			elseif target_type == "REGION" then
				-- REGION
				local target_region = ritual_target:get_target_region();
				
				if target_region:is_null_interface() == false then
					local region_key = target_region:name();
					local comp_scene = "dust_"..region_key;
					local scene_type = dust_default_composite_scene;
					
					if dust_composite_scene_overrides[target_type] ~= nil and dust_composite_scene_overrides[target_type][ritual_key] ~= nil then
						scene_type = dust_composite_scene_overrides[target_type][ritual_key];
					end
					
					cm:add_scripted_composite_scene_to_settlement(comp_scene, scene_type, target_region, 0, 0, true, true, false);
					table.insert(dust_actions, comp_scene);
				end
			elseif target_type == "MILITARY_FORCE" then
				-- FORCE
				local target_force = ritual_target:get_target_force();

				if target_force:is_null_interface() == false and target_force:has_general() == true then
					local general = target_force:general_character();
					local cqi = general:command_queue_index();
					local comp_scene = "dust_"..cqi;
					local scene_type = dust_default_composite_scene;
					local x = general:logical_position_x();
					local y = general:logical_position_y();
						
					if dust_composite_scene_overrides[target_type] ~= nil and dust_composite_scene_overrides[target_type][ritual_key] ~= nil then
						scene_type = dust_composite_scene_overrides[target_type][ritual_key];
					end
					
					cm:add_scripted_composite_scene_to_logical_position(comp_scene, scene_type, x, y, 0, 0, true, true, false);
					table.insert(dust_actions, comp_scene);
				end
			end
		end
		
		if faction:pooled_resource_manager():resource("skv_dust"):is_null_interface() == false then
			if dust_cooldown == 0 then
				local dust = faction:pooled_resource_manager():resource("skv_dust");
				local dust_value = dust:value();
				local dust_max = dust:maximum_value();

				if dust_value < dust_max then
					dust_cooldown = dust_cooldown_reset;
				end
			end
		end
		dust_UpdateUI_skv();
	end
	
	local agents = ritual:characters_who_performed();

	for i = 0, agents:num_items() - 1 do
		local agent = agents:item_at(i);
		cm:add_agent_experience_through_family_member(agent, dust_xp_gain);
	end
end

function dist_ShowCutscene_skv(key, faction, ritual, comp_scene, log_x, log_y, dis_x, dis_y, region)
	local cam_x, cam_y, cam_d, cam_b, cam_h = cm:get_camera_position();
	local cam_fade_in_time = 1;
	local cam_fade_out_time = 1;
	local cam_vfx_play_time = 3;
	local cam_pause_after_fade_before_vfx = 1;

	local local_faction = cm:get_local_faction(true);
	local show_cutscene_local = local_faction == faction:name();
	
	
	if show_cutscene_local == true then
		cm:steal_user_input(true);
		cm:fade_scene(0, cam_fade_in_time);
	end
	
	cm:callback(function()
		if show_cutscene_local == true then
			cm:scroll_camera_with_direction(true, cam_vfx_play_time * 2, {dis_x, dis_y, 10.1, 0.0, 7.7}, {dis_x, dis_y + 2, 13.7, 0.0, 10.7});
			CampaignUI.ToggleCinematicBorders(true);
			cm:fade_scene(1, cam_fade_in_time);
			if region then 
				cm:take_shroud_snapshot();
				cm:make_region_visible_in_shroud(local_faction, region:name());
			end
		end
		
		cm:callback(function()
			-- Execture ritual
			cm:apply_active_ritual(faction, ritual);
			
			-- Apply Composite Scene
			if region == nil then
				cm:add_scripted_composite_scene_to_logical_position(key, comp_scene, log_x, log_y, 0, 0, true, true, false);
				out("add_scripted_composite_scene_to_logical_position - "..log_x..", "..log_y);
			else
				cm:add_scripted_composite_scene_to_settlement(key, comp_scene, region, 0, 0, true, true, false);
			end
			
			if show_cutscene_local == true then
				cm:callback(function()
					cm:fade_scene(0, cam_fade_out_time);
					
					cm:callback(function()
						cm:steal_user_input(false);
						cm:set_camera_position(cam_x, cam_y, cam_d, cam_b, cam_h);
						CampaignUI.ToggleCinematicBorders(false);
						cm:fade_scene(1, cam_fade_in_time);
						cm:restore_shroud_from_snapshot();
					end, cam_fade_out_time);
				end, cam_vfx_play_time);
			end
		end, cam_fade_in_time + cam_pause_after_fade_before_vfx);
	end, cam_fade_in_time);
end

function dust_UpdateCap_skv()
	for i = 1, 5 do
		cm:remove_effect_bundle("wh2_dlc14_bundle_dust_cap_"..i, dust_faction);
	end
	cm:apply_effect_bundle("wh2_dlc14_bundle_dust_cap_"..dust_cap, dust_faction, 0);
	dust_UpdateUI_skv();
end

function dust_UpdateUI_skv()
	local ui_root = core:get_ui_root();
	local bar_ui = find_uicomponent(ui_root, "warpstone_dust_bar");
	
	if bar_ui then
		bar_ui:InterfaceFunction("SetTimer", dust_cooldown);
	end
end

function wh2_dlc14_snikch_shadowy_dealings_skv()
	out("wh2_dlc14_snikch_shadowy_dealings_skv:start ")
end

function wh2_dlc14_snikch_shadowy_dealings_skv_start(faction_name)
	dust_faction = faction_name;
	add_shadowy_dealings_listeners_skv();
end
--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("dust_cap_skv", dust_cap, context);
		cm:save_named_value("dust_cooldown_skv", dust_cooldown, context);
		cm:save_named_value("dust_actions_skv", dust_actions, context);
--		cm:save_named_value("dust_is_new_ganme", dust_is_new_ganme, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			dust_cap = cm:load_named_value("dust_cap_skv", dust_cap, context);
			dust_cooldown = cm:load_named_value("dust_cooldown_skv", dust_cooldown, context);
			dust_actions = cm:load_named_value("dust_actions_skv", dust_actions, context);
--			dust_is_new_ganme = cm:load_named_value("dust_is_new_ganme", true, context);
		end
	end
);