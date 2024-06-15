local Grom_faction = "";

-- blacktoof missions and prophecies seesion --
--blacktoof misiosns, this is the genuine sequence of how they are executed
local BlacktoofMissions = {"wh2_dlc15_grn_grom_black_toof_1", "wh2_dlc15_grn_grom_black_toof_2", "wh2_dlc15_grn_grom_black_toof_3", "wh2_dlc15_grn_grom_black_toof_3_2", "wh2_dlc15_grn_grom_black_toof_4", "wh2_dlc15_grn_grom_black_toof_5_ME"
};
--this is the mission objective for scripted missions, if not scripted, please leave empty string
local BlacktoofMissionsStrings = {"", "wh2_dlc15_obejctive_grom_mission_2", "wh2_dlc15_obejctive_grom_mission_3", "wh2_dlc15_obejctive_grom_mission_3_2", "wh2_dlc15_obejctive_grom_mission_4", ""
};
--this is the payloads
local BlacktoofMissionsPayload = {{}, {"faction_pooled_resource_transaction{resource grn_salvage;factor looting;amount 100;context absolute;}", "money 1200"}, {"faction_pooled_resource_transaction{resource grn_salvage;factor looting;amount 150;context absolute;}", "money 1500"}, {"effect_bundle{bundle_key wh2_dlc15_grom_unlock_special_recipe;turns 0;}", "money 1500"}, {"effect_bundle{bundle_key wh2_dlc15_grn_narration_groms_ready;turns 0;}"}, {}
};
--keeps track of blacktoofmission progress
local BlacktoofMissionsCurrent = 1;
--blacktoof's prophecies tracker, currently they all fire at once, alternatively we random these mission, we keep a list of em
local BlacktoofProphecies = {1, 2 ,3};
local turn_blacktoof_mission = false;
function add_grom_story_listeners_grn(faction_name)
	out("#### Adding Grom Story Listeners grn ####");
	Grom_faction = faction_name
	--don't do anything if grom is not player
	if not cm:get_faction(Grom_faction) or (cm:get_faction(Grom_faction) and not cm:get_faction(Grom_faction):is_human()) then
		return;
	end

	--start blacktoof quest chain and apply yvress block mechanic(only for vortex)
	if false == turn_blacktoof_mission then
		cm:trigger_mission(Grom_faction, "wh2_dlc15_grn_grom_black_toof_1", true);
		core:trigger_event("BlackToofMissionIssued");
		turn_blacktoof_mission = true;
	end
	
	
	--setup blacktoof scripted missions
	if BlacktoofMissionsCurrent <= #BlacktoofMissions then
		core:add_listener(
			"grn_follow_up_mission_trigger_blacktoof_mission",
			"MissionSucceeded",
			true,
			function(context)
				local check_result = false;
				local mission_key = context:mission():mission_record_key();
				--trigger the scripted missions
				for i = 1, #BlacktoofMissions-1 do
					if mission_key == BlacktoofMissions[i] then
						trigger_black_toof_mission_grn(i+1);
					end;
				end;
				--setup the last stage of blacktoof missions
				--give yvresse to grom if not
				--remove yvresse block after final battle
				if mission_key == BlacktoofMissions[#BlacktoofMissions] then
					core:remove_listener("Yvresse_block_listerner_for_player");
					cm:remove_effect_bundle("wh2_dlc15_grom_yvresse_blockade", Grom_faction);
				end	
				--trigger blacktoof's prophecy
				if mission_key == BlacktoofMissions[#BlacktoofMissions - 2] then
					cm:callback(function() setup_black_toofs_prophecies_grn() end, 0.2) -- delay by a tick so the mission succeeded event shows first
				end	
				--trigger the special blacktoof revenge objective
				if mission_key == "wh2_dlc15_grn_grom_black_toof_4" then
					cm:complete_scripted_mission_objective(Grom_faction, "wh_main_long_victory", "complete_blacktoof_revenge", true);
				end	
			end,
		true
		);
		setup_black_toof_mission_listeners_grn(BlacktoofMissionsCurrent);
	end
	
    core:add_listener(
		"wh2_dlc15_grom_blacktoof_prophecy_0",
		"GromUnlockedAllTheCauldronSlots",
		true,
		function(context)
			cm:complete_scripted_mission_objective(Grom_faction, "wh2_dlc15_grom_blacktoof_prophecy_0", "prophecies_0", true);
		end,
		true
	)
end

--this will setup 1 of the 3 prophecies from blacktoof
function setup_black_toofs_prophecies_grn()
	local mission_key = "wh2_dlc15_grom_blacktoof_prophecy_0";
	local script_key = "prophecies_0";
	local condition = "wh2_dlc15_obejctive_grom_mission_extra";
	local reward = {"effect_bundle{bundle_key wh2_dlc15_grom_unlock_special_recipe;turns 0;}", "money 8000"};
	local mm = mission_manager:new(Grom_faction, mission_key);
	mm:add_new_objective("SCRIPTED");
	mm:add_condition("script_key "..script_key);
	mm:add_condition("override_text mission_text_text_"..condition);
	mm:set_mission_issuer("BLACK_TOOF");

	for i = 1, #reward do
		mm:add_payload(reward[i]);
	end
	
	mm:set_should_whitelist(false);
	mm:trigger();
	
--	setup_black_toof_prophecies_listener_grn();
	
	cm:trigger_mission(Grom_faction, "wh2_dlc15_grom_blacktoof_prophecy_1", true);
	cm:trigger_mission(Grom_faction, "wh2_dlc15_grom_blacktoof_prophecy_2", true);
	check_blacktoof_mission_requirement_grn();
end



function trigger_black_toof_mission_grn(index)
	if index > #BlacktoofMissions then
		out("trying to trigger blacktoof mission but out of index");
		return;
	else
		BlacktoofMissionsCurrent = index;
		setup_black_toof_scripted_mission_grn(BlacktoofMissionsCurrent);
	end
end

function setup_black_toof_scripted_mission_grn(index)
	local mission_record = BlacktoofMissions[index];
	if index == #BlacktoofMissions then
		cm:trigger_mission(Grom_faction, mission_record, true);
	elseif BlacktoofMissionsStrings[index] ~= {} then
		local mission_key = mission_record;
		local mm = mission_manager:new(Grom_faction, mission_key);
		mm:add_new_objective("SCRIPTED");
		mm:add_condition("script_key grom_mission_"..tostring(index));
		mm:add_condition("override_text mission_text_text_"..BlacktoofMissionsStrings[index]);
		mm:set_mission_issuer("BLACK_TOOF");

		for i = 1, #BlacktoofMissionsPayload[index] do
			mm:add_payload(BlacktoofMissionsPayload[index][i]);
		end
		mm:set_should_whitelist(false);
		cm:callback(function() mm:trigger() end, 0.2); -- delay by a tick so the mission succeeded event shows first
		
		setup_black_toof_mission_listeners_grn(index);
	end
end

function setup_black_toof_mission_listeners_grn(index)
	if index == 2 then
		--listen to the event when a dish is cooked
		core:add_listener(
			"grn_balcktoof_listerner"..index,
			"FactionCookedDish",
			true,
			function(context)
				cm:complete_scripted_mission_objective(Grom_faction, BlacktoofMissions[index], "grom_mission_"..tostring(index), true);
			end,
		true
		);
	elseif index == 3 then
		--listen to the event when a food merchant is met
		core:add_listener(
			"grn_balcktoof_listerner"..index,
			"ScriptEventGromsCauldronGromMeetsTheFoodMerchantress",
			true,
			function(context)
				cm:complete_scripted_mission_objective(Grom_faction, BlacktoofMissions[index], "grom_mission_"..tostring(index), true);
			end,
		true
		);	
	elseif index == 4 then
		--listen to the event when a food merchant is met
		core:add_listener(
			"grn_balcktoof_listerner"..index,
			"GromHasUnlockedEnoughIngredients",
			true,
			function(context)
				cm:complete_scripted_mission_objective(Grom_faction, BlacktoofMissions[index], "grom_mission_"..tostring(index), true);
			end,
		true
		);
	elseif index == 5 then
		--listen to the event when Grom's trait is lv3
		core:add_listener(
			"grn_balcktoof_listerner"..index,
			"GromEatenEnoughRecipes",
			true,
			function(context)
				cm:complete_scripted_mission_objective(Grom_faction, BlacktoofMissions[index], "grom_mission_"..tostring(index), true);
			end,
		true
		);
	else
		out("trying to trigger blacktoof mission listener but out of index");
		return;
	end
end

function wh2_dlc15_grom_story_grn()
	out("wh2_dlc15_grom_story_grn start!");
end
--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("BlacktoofMissionsCurrent_grn", BlacktoofMissionsCurrent, context);
		cm:save_named_value("BlacktoofProphecies_grn", BlacktoofProphecies, context);
		cm:save_named_value("turn_blacktoof_mission", turn_blacktoof_mission, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			BlacktoofMissionsCurrent = cm:load_named_value("BlacktoofMissionsCurrent_grn", BlacktoofMissionsCurrent, context);
			BlacktoofProphecies = cm:load_named_value("BlacktoofProphecies_grn", BlacktoofProphecies, context);
			turn_blacktoof_mission = cm:load_named_value("turn_blacktoof_mission", false, context);
		end
	end
);