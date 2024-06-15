local ikit_faction_cqi = 0;
local ikit_faction = "";
local ikit_subtype = "wh2_dlc12_skv_ikit_claw";
local engineer_subtype = "wh2_main_skv_warlock_engineer";
local master_engineer_subtype = "wh2_dlc12_skv_warlock_master";
local ikit_faction_name = "wh2_main_skv_clan_skryre";

-- key, progress_threshold, progress_reward
local workshop_category_keys = {
	weapon_team = "weapon_team",
	doom_wheel = "doom_wheel",
	doom_flayer = "doom_flayer"
};

local workshop_category_detail = {
	-- Rewards are keyed by the index of the progress bar at which they unlock. i.e. you do 2 Weapons Team upgrades and then get the reward at index [2].
	-- Worried about Key-Value-Pair iteration and desynchs? It should be fine, as only one of these reward entries should ever be accessed and used
	-- in a given upgrade. There's no chance of accidentally looking up items in the wrong order and causing a desych.
	[workshop_category_keys.weapon_team] =
	{
		rewards = {
			[2] = {ancillary = "wh2_dlc12_anc_magic_standard_incendiary_rounds"},
			[4] = {ancillary = "wh2_dlc12_anc_magic_standard_cape_of_sniper"},
			[5] = {unit = "wh2_dlc12_skv_inf_warpfire_thrower_ror_tech_lab_0"},
			[6] = {unit = "wh2_dlc12_skv_art_warplock_jezzails_ror_tech_lab_0"},
			[7] = {unit = "wh2_dlc12_skv_inf_ratling_gun_ror_tech_lab_0"},
		}
	},
	[workshop_category_keys.doom_wheel] =
	{
		rewards = {
			[2] = {ancillary = "wh2_dlc12_anc_talisman_warp_field_generator"},
			[4] = {ancillary = "wh2_dlc12_anc_weapon_thing_zapper"},
			[6] = {ancillary = "wh2_dlc12_anc_enchanted_item_modulated_doomwheel_assembly_kit"},
			[7] = {ancillary = "wh2_dlc12_anc_enchanted_item_warp_lightning_battery"},
			[8] = {unit = "wh2_dlc12_skv_veh_doomwheel_ror_tech_lab_0"},
		}
	},
	[workshop_category_keys.doom_flayer] =
	{
		rewards = {
			[2] = {ancillary = "wh2_dlc12_anc_armour_alloy_shield"},
			[4] = {ancillary = "wh2_dlc12_anc_weapon_retractable_fistblade"},
			[6] = {ancillary = "wh2_dlc12_anc_weapon_mechanical_arm"},
			[7] = {ancillary = "wh2_dlc12_anc_armour_power_armour"},
			[8] = {unit = "wh2_dlc12_skv_veh_doom_flayer_ror_tech_lab_0"},
		}
	},
};

local workshop_category_progress = {
	[workshop_category_keys.weapon_team] = 0,
	[workshop_category_keys.doom_wheel] = 0,
	[workshop_category_keys.doom_flayer] = 0
};

local workshop_upgrade_incidents = {
	"",
	"wh2_dlc12_incident_skv_workshop_upgrade_2",
	"wh2_dlc12_incident_skv_workshop_upgrade_3",
	"wh2_dlc12_incident_skv_workshop_upgrade_4"
};

local workshop_nuke_rite_keys = {
	"wh2_dlc12_ikit_workshop_nuke_part_0",
	"wh2_dlc12_ikit_workshop_nuke_part_1",
	"wh2_dlc12_ikit_workshop_nuke_part_2",
	"wh2_dlc12_ikit_workshop_nuke_part_3",
	"wh2_dlc12_ikit_workshop_nuke_part_4",
	"wh2_dlc12_ikit_workshop_nuke_part_5"
};

local workshop_rite_details = {
	["wh2_dlc12_ikit_workshop_gatling_part_1"] = {category = workshop_category_keys.weapon_team, researched = false},
	["wh2_dlc12_ikit_workshop_jezail_part_0"] = {category = workshop_category_keys.weapon_team, researched = false},
	["wh2_dlc12_ikit_workshop_warpfire_part_2"] = {category = workshop_category_keys.weapon_team, researched = false},
	["wh2_dlc12_ikit_workshop_poison_wind_globaldier_0"] = {category = workshop_category_keys.weapon_team, researched = false}, 
	["wh2_dlc12_ikit_workshop_poison_wind_mortar_0"] = {category = workshop_category_keys.weapon_team, researched = false}, 
	["wh2_dlc12_ikit_workshop_warpgrinder_0"] = {category = workshop_category_keys.weapon_team, researched = false}, 
	["wh2_dlc12_ikit_workshop_doomwheel_part_0"] = {category = workshop_category_keys.doom_wheel, researched = false},
	["wh2_dlc12_ikit_workshop_doomwheel_part_2"] = {category = workshop_category_keys.doom_wheel, researched = false},
	["wh2_dlc12_ikit_workshop_doomwheel_part_6"] = {category = workshop_category_keys.doom_wheel, researched = false},
	["wh2_dlc12_ikit_workshop_doomwheel_part_9"] = {category = workshop_category_keys.doom_wheel, researched = false},
	["wh2_dlc12_ikit_workshop_doomflayer_part_1"] = {category = workshop_category_keys.doom_flayer, researched = false},
	["wh2_dlc12_ikit_workshop_doomflayer_part_5"] = {category = workshop_category_keys.doom_flayer, researched = false},
	["wh2_dlc12_ikit_workshop_doomflayer_part_6"] = {category = workshop_category_keys.doom_flayer, researched = false},
	["wh2_dlc12_ikit_workshop_doomflayer_part_9"] = {category = workshop_category_keys.doom_flayer, researched = false},
	["wh2_dlc12_ikit_workshop_gatling_part_2"] = {category = workshop_category_keys.weapon_team, researched = false},
	["wh2_dlc12_ikit_workshop_jezail_part_2"] = {category = workshop_category_keys.weapon_team, researched = false},
	["wh2_dlc12_ikit_workshop_warpfire_part_1"] = {category = workshop_category_keys.weapon_team, researched = false},
	["wh2_dlc12_ikit_workshop_poison_wind_globaldier_1"] = {category = workshop_category_keys.weapon_team, researched = false}, 
	["wh2_dlc12_ikit_workshop_poison_wind_mortar_1"] = {category = workshop_category_keys.weapon_team, researched = false}, 
	["wh2_dlc12_ikit_workshop_warpgrinder_1"] = {category = workshop_category_keys.weapon_team, researched = false}, 
	["wh2_dlc12_ikit_workshop_doomwheel_part_1"] = {category = workshop_category_keys.doom_wheel, researched = false},
	["wh2_dlc12_ikit_workshop_doomwheel_part_4"] = {category = workshop_category_keys.doom_wheel, researched = false},
	["wh2_dlc12_ikit_workshop_doomwheel_part_8"] = {category = workshop_category_keys.doom_wheel, researched = false},
	["wh2_dlc12_ikit_workshop_doomflayer_part_0"] = {category = workshop_category_keys.doom_flayer, researched = false},
	["wh2_dlc12_ikit_workshop_doomflayer_part_2"] = {category = workshop_category_keys.doom_flayer, researched = false},
	["wh2_dlc12_ikit_workshop_doomflayer_part_7"] = {category = workshop_category_keys.doom_flayer, researched = false},
	["wh2_dlc12_ikit_workshop_gatling_part_0"] = {category = workshop_category_keys.weapon_team, researched = false},
	["wh2_dlc12_ikit_workshop_jezail_part_1"] = {category = workshop_category_keys.weapon_team, researched = false},
	["wh2_dlc12_ikit_workshop_warpfire_part_0"] = {category = workshop_category_keys.weapon_team, researched = false},
	["wh2_dlc12_ikit_workshop_poison_wind_globaldier_2"] = {category = workshop_category_keys.weapon_team, researched = false}, 
	["wh2_dlc12_ikit_workshop_poison_wind_mortar_2"] = {category = workshop_category_keys.weapon_team, researched = false}, 
	["wh2_dlc12_ikit_workshop_warpgrinder_2"] = {category = workshop_category_keys.weapon_team, researched = false}, 
	["wh2_dlc12_ikit_workshop_doomwheel_part_5"] = {category = workshop_category_keys.doom_wheel, researched = false},
	["wh2_dlc12_ikit_workshop_doomwheel_part_7"] = {category = workshop_category_keys.doom_wheel, researched = false},
	["wh2_dlc12_ikit_workshop_doomflayer_part_3"] = {category = workshop_category_keys.doom_flayer, researched = false},
	["wh2_dlc12_ikit_workshop_doomflayer_part_8"] = {category = workshop_category_keys.doom_flayer, researched = false},
	["wh2_dlc12_ikit_workshop_doomwheel_part_3"] = {category = workshop_category_keys.doom_wheel, researched = false},
	["wh2_dlc12_ikit_workshop_doomflayer_part_4"] = {category = workshop_category_keys.doom_flayer, researched = false},
	["wh2_dlc12_ikit_workshop_nuke_part_0"] = {category = "", researched = false},
	["wh2_dlc12_ikit_workshop_nuke_part_1"] = {category = "", researched = false},
	["wh2_dlc12_ikit_workshop_nuke_part_2"] = {category = "", researched = false},
	["wh2_dlc12_ikit_workshop_nuke_part_3"] = {category = "", researched = false},
	["wh2_dlc12_ikit_workshop_nuke_part_4"] = {category = "", researched = false},
	["wh2_dlc12_ikit_workshop_nuke_part_5"] = {category = "", researched = false}
};

-- Each upgrade requires a workshop level of the corresponding index to be researched.
local workshop_rite_keys = {
	{	"wh2_dlc12_ikit_workshop_gatling_part_1", 
		"wh2_dlc12_ikit_workshop_jezail_part_0",  
		"wh2_dlc12_ikit_workshop_warpfire_part_2", 
		"wh2_dlc12_ikit_workshop_doomwheel_part_0", 
		"wh2_dlc12_ikit_workshop_doomwheel_part_2", 
		"wh2_dlc12_ikit_workshop_doomwheel_part_6", 
		"wh2_dlc12_ikit_workshop_doomwheel_part_9", 
		"wh2_dlc12_ikit_workshop_doomflayer_part_1", 
		"wh2_dlc12_ikit_workshop_doomflayer_part_5", 
		"wh2_dlc12_ikit_workshop_doomflayer_part_6",
		"wh2_dlc12_ikit_workshop_doomflayer_part_9",
		"wh2_dlc12_ikit_workshop_poison_wind_globaldier_0",
		"wh2_dlc12_ikit_workshop_poison_wind_mortar_0",
		"wh2_dlc12_ikit_workshop_warpgrinder_0"
	},
	{	"wh2_dlc12_ikit_workshop_gatling_part_2",
		"wh2_dlc12_ikit_workshop_jezail_part_2", 
		"wh2_dlc12_ikit_workshop_warpfire_part_1",
		"wh2_dlc12_ikit_workshop_doomwheel_part_1",
		"wh2_dlc12_ikit_workshop_doomwheel_part_4",
		"wh2_dlc12_ikit_workshop_doomwheel_part_8",
		"wh2_dlc12_ikit_workshop_doomflayer_part_0",
		"wh2_dlc12_ikit_workshop_doomflayer_part_2",
		"wh2_dlc12_ikit_workshop_doomflayer_part_7",
		"wh2_dlc12_ikit_workshop_poison_wind_globaldier_1",
		"wh2_dlc12_ikit_workshop_poison_wind_mortar_1",
		"wh2_dlc12_ikit_workshop_warpgrinder_1"
	},
	{	"wh2_dlc12_ikit_workshop_gatling_part_0", 
		"wh2_dlc12_ikit_workshop_jezail_part_1", 
		"wh2_dlc12_ikit_workshop_warpfire_part_0", 
		"wh2_dlc12_ikit_workshop_doomwheel_part_5", 
		"wh2_dlc12_ikit_workshop_doomwheel_part_7", 
		"wh2_dlc12_ikit_workshop_doomflayer_part_3",
		"wh2_dlc12_ikit_workshop_doomflayer_part_8",
		"wh2_dlc12_ikit_workshop_poison_wind_globaldier_2",
		"wh2_dlc12_ikit_workshop_poison_wind_mortar_2",
		"wh2_dlc12_ikit_workshop_warpgrinder_2"
	},
	{	"wh2_dlc12_ikit_workshop_doomwheel_part_3", 
		"wh2_dlc12_ikit_workshop_doomflayer_part_4"
	}
};

local nuke_resource_key = "skv_nuke";
local nuke_rite_key = "wh2_dlc12_ikit_nuke_rite";

local nuke_resource_factor_key = {
	["add"] = "workshop_production",
	["negative"] = "consumed_in_battle"
};

local nuke_limit_default = 5;
local nuke_limit_improved = 8;
local nuke_limit = 5;

local additional_nuke_chance = 25;

local nuke_effect_bundle_key = {
	"wh2_dlc12_nuke_ability_enable",
	"wh2_dlc12_nuke_ability_upgrade_enable"
};

local nuke_ability_key = "wh2_dlc12_army_abilities_warpstorm_doomrocket";
local nuke_ability_upgrade_key = "wh2_dlc12_army_abilities_warpstorm_doomrocket_upgraded";

local nuke_drop_chance_current = 0;
local nuke_replenish_effect_bundle = "wh2_dlc12_force_temporary_replenish";

local reactor_resource_key = "skv_reactor_core";

local reactor_resource_factor_key = {
	["add"] = "discovered_in_battle",
	["add_alt"] = "hero_actions",
	["add_mission"] = "workshop_upgrade",
	["negative"] = "workshop_research"
};

local reactor_add_chances = {
	[ikit_subtype] = {40, 0},
	[master_engineer_subtype] = {20,0},
	[engineer_subtype] = {30, 0}
};

local workshop_level_dummy_effect_bundle = {
	"wh2_dlc12_workshop_level_0_dummy",
	"wh2_dlc12_workshop_level_1_dummy",
	"wh2_dlc12_workshop_level_2_dummy",
	"wh2_dlc12_workshop_level_3_dummy"
};

local workshop_level_reactor_core_reward = 5;

local workshop_lvl_missions = {
	{"wh2_dlc12_ikit_workshop_tier_1_0", "wh2_dlc12_ikit_workshop_tier_1_1", "wh2_dlc12_ikit_workshop_tier_1_2"},
	{"wh2_dlc12_ikit_workshop_tier_2_0", "wh2_dlc12_ikit_workshop_tier_2_1", "wh2_dlc12_ikit_workshop_tier_2_2"},
	{"wh2_dlc12_ikit_workshop_tier_3_1", "wh2_dlc12_ikit_workshop_tier_3_2"},
	{}
};

local workshop_lvl_missions_scripted = {
	"wh2_dlc12_ikit_workshop_tier_1_2",
	"wh2_dlc12_ikit_workshop_tier_2_0",
	"wh2_dlc12_ikit_workshop_tier_2_1",
	"wh2_dlc12_ikit_workshop_tier_3_1"
};

local workshop_lvl_missions_scripted_listener = {
	["wh2_dlc12_ikit_workshop_tier_1_2"] = false,
	["wh2_dlc12_ikit_workshop_tier_2_0"] = false,
	["wh2_dlc12_ikit_workshop_tier_2_1"] = false,
	["wh2_dlc12_ikit_workshop_tier_3_0"] = false,
	["wh2_dlc12_ikit_workshop_tier_3_1"] = false
};

local workshop_lvl_missions_scripted_listener_default = {
	["wh2_dlc12_ikit_workshop_tier_1_2"] = false,
	["wh2_dlc12_ikit_workshop_tier_2_0"] = false,
	["wh2_dlc12_ikit_workshop_tier_2_1"] = false,
	["wh2_dlc12_ikit_workshop_tier_3_0"] = false,
	["wh2_dlc12_ikit_workshop_tier_3_1"] = false
};

local workshop_lvl_progress = {
	{false, false, false},
	{false, false, false},
	{false, false},
	{}
};
 
local current_workshop_lvl = 4;

local initialized = false;

function check_and_update_rite_details_skv()
	for i = 1, current_workshop_lvl do
		unlock_rites_skv(i);
	end
end





function unlock_rites_skv(lvl) 
	if lvl <= #workshop_rite_keys then
		local ikit_faction_interface = cm:model():world():faction_by_key(ikit_faction);
		for i=1, #workshop_rite_keys[lvl] do
			cm:unlock_ritual(ikit_faction_interface, workshop_rite_keys[lvl][i]);
		end
	end
end


function add_nuke_listeners()
	-- nuke control
	-- producing nuke
	core:add_listener(
		"ritual_started_ikit_producing_nuke_skv",
		"RitualStartedEvent",
		function(context)
			return context:ritual():ritual_key() == nuke_rite_key;
		end,
		function()
			cm:faction_add_pooled_resource(ikit_faction, nuke_resource_key, nuke_resource_factor_key["add"], 1);
			
			if workshop_rite_details[workshop_nuke_rite_keys[5]].researched and additional_nuke_chance > cm:random_number(100) then
				cm:faction_add_pooled_resource(ikit_faction, nuke_resource_key, nuke_resource_factor_key["add"], 1);
			end;
			
			updated_nuke_functions_based_on_nuke_resource_skv_expand();
		end,
		true
	);

	-- reducing nuke
	core:add_listener(
		"battle_completed_ikit_reducing_nuke_skv",
		"BattleCompleted",
		function(context)
			local pb = cm:model():pending_battle();
			return pb:has_been_fought() and cm:pending_battle_cache_faction_is_involved(ikit_faction) and (pb:get_how_many_times_ability_has_been_used_in_battle(ikit_faction_cqi, nuke_ability_key) > 0 or pb:get_how_many_times_ability_has_been_used_in_battle(ikit_faction_cqi, nuke_ability_upgrade_key) > 0);
		end,
		function()
			cm:faction_add_pooled_resource(ikit_faction, nuke_resource_key, nuke_resource_factor_key["negative"], -1);
			updated_nuke_functions_based_on_nuke_resource_skv_expand();
			
			--checking scripted missions
--			if workshop_lvl_missions_scripted_listener[workshop_lvl_missions_scripted[1]] then
--				cm:complete_scripted_mission_objective(ikit_faction, workshop_lvl_missions_scripted[1], workshop_lvl_missions_scripted[1], true);
--				workshop_lvl_missions_scripted_listener[workshop_lvl_missions_scripted[1]] = false;
--			end;
			
			--checking if nuke parts researched, additional reward
			if workshop_rite_details[workshop_nuke_rite_keys[3]].researched then
				cm:faction_add_pooled_resource(ikit_faction, reactor_resource_key, reactor_resource_factor_key["add"], 1);
			end;
			
			--checking if nuke parts researched, additional replenish
			if workshop_rite_details[workshop_nuke_rite_keys[4]].researched then
				if cm:pending_battle_cache_num_attackers() >= 1 then
					for i = 1, cm:pending_battle_cache_num_attackers() do
						local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
						local character = cm:get_character_by_cqi(this_char_cqi);
						
						if character and character:faction():name() == ikit_faction then
							cm:apply_effect_bundle_to_characters_force(nuke_replenish_effect_bundle, this_char_cqi, 5);
						end;
					end;
				end;
				
				if cm:pending_battle_cache_num_defenders() >= 1 then
					for i = 1, cm:pending_battle_cache_num_defenders() do
						local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
						local character = cm:get_character_by_cqi(this_char_cqi);
						
						if character and character:faction():name() == ikit_faction then
							cm:apply_effect_bundle_to_characters_force(nuke_replenish_effect_bundle, this_char_cqi, 5);
						end;
					end;
				end;
			end;
			
			local ikit_pooled_resource_manager = cm:get_faction(ikit_faction):pooled_resource_manager();
			
			if ikit_pooled_resource_manager:resource(nuke_resource_key):value() == 0 and ikit_pooled_resource_manager:resource(reactor_resource_key):value() > 3 then
				core:trigger_event("ScriptEventPlayerNukeReadyToBuy");
			end;
		end,
		true
	);
	-- progress reward
	core:add_listener(
		"ritual_completed_ikit_progress_reward_skv",
		"RitualCompletedEvent",
		function(context)
			return workshop_rite_details[context:ritual():ritual_key()];
		end,
		function(context)
			--check if that's the proper rite
			local faction = context:performing_faction();
			local ritual = context:ritual();
			local ritual_key = ritual:ritual_key();
			if workshop_rite_details[ritual_key] ~= nil then
				local rite_details = workshop_rite_details[ritual_key];

				rite_details.researched = true;
				updated_nuke_functions_based_on_nuke_resource_skv_expand();
				if workshop_category_progress[rite_details.category] ~= nil then
					workshop_category_progress[rite_details.category] = workshop_category_progress[rite_details.category]+1;
					local total_count = 0;
					--intervention events--
					for key, value in pairs(workshop_category_keys) do
						total_count = total_count + workshop_category_progress[value];
					end

					if total_count >= 5 then
						core:trigger_event("ScriptEventPlayer5WorkshopUpgrades");
					elseif total_count >= 2 then
						core:trigger_event("ScriptEventPlayer2WorkshopUpgrades");
					end 
					if ritual_key == workshop_nuke_rite_keys[2] then
						--increase stockpile
						nuke_limit = nuke_limit_improved;
					end
					if ritual_key == workshop_nuke_rite_keys[6] then
						updated_nuke_functions_based_on_nuke_resource_skv_expand();
					end
					
					local category_rewards = workshop_category_detail[rite_details.category].rewards;
					local category_progress = workshop_category_progress[rite_details.category];
					local reward = category_rewards[category_progress];

					if reward ~= nil then
						local reward_found = false;
						if reward.ancillary ~= nil then
							reward_found = true;

							--give ancillary
							out("Ikit Workshop: Unlocking ancillary " .. reward.ancillary);
							cm:add_ancillary_to_faction(faction, reward.ancillary, false);
						end
						if reward.unit ~= nil then
							reward_found = true;

							--give unit
							out("Ikit Workshop: Unlocking unit " .. reward.unit);
							--cm:remove_event_restricted_unit_record_for_faction(reward.unit, ikit_faction);
							add_unit_faction_mercenary_pool_expand(ikit_faction,reward.unit);
							cm:trigger_incident(ikit_faction, reward.unit, true);
						end

						if not reward_found then
							script_error(string.format("Ikit Workshop upgrades of category '%s' had a reward item unlocked at workshop progress '%i', but this category had no reward type of the expected keys. An 'ancillary' or 'unit' is needed as a reward.",
								rite_details.category, category_progress));
						end
					end
				end
			end
		end,
		true
	);


	-- reactor core control
	-- post battle loot
	core:add_listener(
		"battle_completed_ikit_post_battle_loot_skv",
		"BattleCompleted",
		function()
			return cm:pending_battle_cache_faction_is_involved(ikit_faction);
		end,
		function(context)
					-- generate loot tables and check skills and other factors that affects loot chance
		local loot_rolls_ikit = {};
		local loot_rolls_master_engineer = {};
		local function add_character_to_loot_roll(cqi, faction_name)
			local character = cm:get_character_by_cqi(cqi);
			
			if character and faction_name == ikit_faction and character:won_battle() then
				local subtype = character:character_subtype_key();
				
				if subtype == ikit_subtype then
					local characters_chance = reactor_add_chances[ikit_subtype][1] + cm:get_characters_bonus_value(character, "reactor_core_chance")
					table.insert(loot_rolls_ikit, {characters_chance, reactor_add_chances[ikit_subtype][2]});
				elseif subtype == master_engineer_subtype then
					local characters_chance = reactor_add_chances[master_engineer_subtype][1] + cm:get_characters_bonus_value(character, "reactor_core_chance")
					table.insert(loot_rolls_master_engineer, {characters_chance, reactor_add_chances[master_engineer_subtype][2]});
				end;
			end;
		end;
		
		if cm:pending_battle_cache_num_attackers() >= 1 then
			for i = 1, cm:pending_battle_cache_num_attackers() do
				local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
				
				add_character_to_loot_roll(this_char_cqi, current_faction_name);
			end;
		end;
		
		if cm:pending_battle_cache_num_defenders() >= 1 then
			for i = 1, cm:pending_battle_cache_num_defenders() do
				local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
				
				add_character_to_loot_roll(this_char_cqi, current_faction_name);
			end;
		end;
		
		-- process loot
		process_reactor_loot_rolls(loot_rolls_ikit, ikit_subtype);
		process_reactor_loot_rolls(loot_rolls_master_engineer, master_engineer_subtype);

		end,
		true
	);
	-- agent action loot
	core:add_listener(
		"character_character_target_action_ikit_agent_action_loot_skv",
		"CharacterCharacterTargetAction",
		function(context)
			local character = context:character();
			return (context:mission_result_critial_success() or context:mission_result_success()) and character:character_subtype_key() == engineer_subtype and character:faction():name() == ikit_faction and context:target_character():faction():name() ~= ikit_faction;
		end,
		function()
			process_reactor_loot_rolls({reactor_add_chances[engineer_subtype]}, engineer_subtype);
		end,
		true
	);

	core:add_listener(
		"character_garrison_target_action_ikit_agent_action_loot_skv",
		"CharacterGarrisonTargetAction",
		function(context)
			local character = context:character();
			return (context:mission_result_critial_success() or context:mission_result_success()) and character:character_subtype_key() == engineer_subtype and character:faction():name() == ikit_faction;
		end,
		function()
			process_reactor_loot_rolls({reactor_add_chances[engineer_subtype]}, engineer_subtype);
		end,
		true
	);
end


-- controlling nuke and rite availability
function updated_nuke_functions_based_on_nuke_resource_skv_expand()
	local ikit_faction_interface = cm:model():world():faction_by_key(ikit_faction);
	local nuke_resource          = ikit_faction_interface:pooled_resource_manager():resource(nuke_resource_key);
	local nuke_resource_amount   = nuke_resource:value();

	if nuke_resource_amount == 0 then
		--nuke is 0 and remove effect bundle
		cm:remove_effect_bundle(nuke_effect_bundle_key[1], ikit_faction);
		
		if workshop_rite_details[workshop_nuke_rite_keys[6]].researched then
			cm:remove_effect_bundle(nuke_effect_bundle_key[2], ikit_faction);
		end;
	else
		-- nuke is higher than 0 and apply effect bundle
		cm:apply_effect_bundle(nuke_effect_bundle_key[1], ikit_faction, 0);
		
		if workshop_rite_details[workshop_nuke_rite_keys[6]].researched then
			cm:remove_effect_bundle(nuke_effect_bundle_key[1], ikit_faction);
			cm:apply_effect_bundle(nuke_effect_bundle_key[2], ikit_faction, 0);
		end

		if nuke_resource_amount == nuke_resource:maximum_value() then
			--nuke is max
			--lock rite
			cm:lock_ritual(ikit_faction_interface, nuke_rite_key);
		else 
			cm:unlock_ritual(ikit_faction_interface, nuke_rite_key);
		end
	end
end



function process_reactor_loot_rolls_skv(loot_rolls, subtype_index)
	local local_faction_name = cm:get_local_faction_name(true);
	
	for i = 1, #loot_rolls do
		if loot_rolls[i][1] * (reactor_add_chances[subtype_index][2] + 1) > cm:random_number(100) then
			if subtype_index == engineer_subtype then
				cm:faction_add_pooled_resource(ikit_faction, reactor_resource_key, reactor_resource_factor_key["add_alt"], 1);
			else
				cm:faction_add_pooled_resource(ikit_faction, reactor_resource_key, reactor_resource_factor_key["add"], 1);
			end;
				
			if local_faction_name and local_faction_name == ikit_faction then
				find_uicomponent(core:get_ui_root(), "hud_campaign"):InterfaceFunction("ShowPooledResourceAnimation", reactor_resource_key, 1);
				
				find_uicomponent(core:get_ui_root(), "cores_icon"):TriggerAnimation("play");
			end;
			
			reactor_add_chances[subtype_index][2] = 0; 
		else
			reactor_add_chances[subtype_index][2] = reactor_add_chances[subtype_index][2] + 1;
		end;
	end;
end;



function add_unit_faction_mercenary_pool_expand(faction_key, unit_key)
	out("shy add "..unit_key.." to "..faction_key);
	cm:add_unit_to_faction_mercenary_pool(
		cm:model():world():faction_by_key(faction_key),
		unit_key,
		"renown",
		1, -- unit count
		100, -- replenishment
		10, -- max_units
		0.10, -- max_units_replenished_per_turn
		"",
		"",
		"", -- restrictions
		true,
		unit_key
	);
end

local function show_ikit_workshop_ui(state)
		
	local ui_root = core:get_ui_root();	
	out("shy ikit print:");
	local ui_button = find_uicomponent(ui_root, "faction_buttons_docker", "button_group_management", "button_ikit_workshop");
	out("shy ikit print:1");
	if not ui_button then
	out("shy ERROR: button find failed!");	
		return false;	
	end;
    ui_button:SetVisible(state);	
end

function wh2_dlc12_ikit_workshop_for_skv()	
	out("shy:nuke key is "..nuke_resource_key);
--	show_ikit_workshop_ui(true);
    print_all_uicomponent_children(core:get_ui_root());
	if ikit_faction ~= "" then
		ikit_faction_cqi = cm:model():world():faction_by_key(ikit_faction):command_queue_index();
		check_and_update_rite_details_skv();
		add_nuke_listeners();
	end
	core:add_listener(
		"ikit_faction_joins_confederation",
		"FactionJoinsConfederation",
		function(context)
			local faction_name = context:faction():name();		
			out("shy:faction_name"..faction_name);
			return faction_name == ikit_faction_name;
		end,
		function(context)
			local faction = context:confederation();
			local confederation_name = context:confederation():name();
			out("shy:confederation_name"..confederation_name);
			local faction_name_log = context:faction():name();
			out("shy:faction_name_log"..faction_name_log);
			if faction:is_human() and ikit_faction == "" then
				ikit_faction = confederation_name;
				out("shy:show_ikit_workshop_faction"..ikit_faction);
				ikit_faction_cqi = cm:model():world():faction_by_key(ikit_faction):command_queue_index();
				add_nuke_listeners();
				show_ikit_workshop_ui(true);	
				check_and_update_rite_details_skv();
				updated_nuke_functions_based_on_nuke_resource_skv_expand();				
			else	
				out("shy:fation is not hunman");
			end;
		end,
		true
	);
	
	if cm:is_new_game() then
		local human_factions = cm:get_human_factions();  
--		out("shy:ikt r "..tostring(show_ikit_workshop));	
		for i = 1, #human_factions do    
			local faction = cm:get_faction(human_factions[i]);
			if faction:is_human() then
				local faction_name = faction:name();
				out("shy:faction_name_skv"..faction_name);
--				out("shy:sw r "..tostring(show_ikit_workshop));
				if faction_name ~= ikit_faction_name then				
					-- --del one nuke
					cm:faction_add_pooled_resource(faction_name, nuke_resource_key, nuke_resource_factor_key["negative"], -1);						
					cm:faction_add_pooled_resource(faction_name, reactor_resource_key, reactor_resource_factor_key["negative"], -5);						
				end;
			end;       
		end;
	end;
	
	if ikit_faction ~= ""then
		local human_factions = cm:get_human_factions();  
		out("shy:ikt r "..tostring(ikit_faction));	
		for i = 1, #human_factions do    
			local faction = cm:get_faction(human_factions[i]);
			if faction:is_human() then
				local faction_name = faction:name();
				out("shy:faction_name_skv"..faction_name);
				out("shy:sw r "..tostring(ikit_faction));
				if faction_name == ikit_faction then			
					show_ikit_workshop_ui(true);		
				end;
			end;       
		end;
	end;
	if initialized == false and ikit_faction ~= "" then
		--ikit_faction_cqi = cm:model():world():faction_by_key(ikit_faction):command_queue_index();		
		initialized = true;		
		--cm:faction_add_pooled_resource(ikit_faction, reactor_resource_key, reactor_resource_factor_key["add"], 5);
		--cm:faction_add_pooled_resource(ikit_faction, nuke_resource_key, nuke_resource_factor_key["add"], 1);
		updated_nuke_functions_based_on_nuke_resource_skv_expand();		
	end
end



cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("workshop_lvl_missions_scripted_listener_skv", workshop_lvl_missions_scripted_listener, context);
		cm:save_named_value("workshop_lvl_progress_skv", workshop_lvl_progress, context);
		cm:save_named_value("current_workshop_lvl_skv", current_workshop_lvl, context);
		cm:save_named_value("nuke_limit_skv", nuke_limit, context);
		cm:save_named_value("workshop_category_progress_skv", workshop_category_progress, context);
		cm:save_named_value("initialized_skv", initialized, context);
		cm:save_named_value("nuke_drop_chance_current_skv", nuke_drop_chance_current, context);
		cm:save_named_value("reactor_add_chances_skv", reactor_add_chances, context);
		cm:save_named_value("workshop_rite_details_skv", workshop_rite_details, context);
		cm:save_named_value("ikit_faction_skv", ikit_faction, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			workshop_lvl_missions_scripted_listener = cm:load_named_value("workshop_lvl_missions_scripted_listener_skv", workshop_lvl_missions_scripted_listener_default, context);
			workshop_lvl_progress = cm:load_named_value("workshop_lvl_progress_skv", workshop_lvl_progress, context);
			current_workshop_lvl = cm:load_named_value("current_workshop_lvl_skv", 1, context);
			nuke_limit = cm:load_named_value("nuke_limit_skv", nuke_limit_default, context);
			workshop_category_progress = cm:load_named_value("workshop_category_progress_skv", workshop_category_progress, context);
			initialized = cm:load_named_value("initialized_skv", false, context);
			nuke_drop_chance_current = cm:load_named_value("nuke_drop_chance_current_skv", 0, context);
			reactor_add_chances = cm:load_named_value("reactor_add_chances_skv", reactor_add_chances, context);
			workshop_rite_details = cm:load_named_value("workshop_rite_details_skv", workshop_rite_details, context);
			ikit_faction = cm:load_named_value("ikit_faction_skv", "", context);
		end;
	end
);