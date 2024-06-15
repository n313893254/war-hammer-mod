local throt_faction_name = ""
local throt_faction_key = "wh2_main_skv_clan_moulder"

-- list of all available mutations, categorised by infantry and monster sections
local flesh_lab_mutation_list = {	
	["inf"] = {
		["wh2_dlc16_throt_flesh_lab_inf_aug_0"] = true,
		["wh2_dlc16_throt_flesh_lab_inf_aug_1"] = true,
		["wh2_dlc16_throt_flesh_lab_inf_aug_2"] = true,
		["wh2_dlc16_throt_flesh_lab_inf_aug_3"] = true,
		["wh2_dlc16_throt_flesh_lab_inf_aug_4"] = true,
		["wh2_dlc16_throt_flesh_lab_inf_aug_5"] = true,
		["wh2_dlc16_throt_flesh_lab_inf_aug_6"] = true,
		["wh2_dlc16_throt_flesh_lab_inf_aug_7"] = true,
		["wh2_dlc16_throt_flesh_lab_inf_aug_8"] = true,
		["wh2_dlc16_throt_flesh_lab_inf_aug_9"] = true,
		["wh2_dlc16_throt_flesh_lab_inf_aug_10"] = true,
		["wh2_dlc16_throt_flesh_lab_inf_aug_11"] = true,
		["wh2_dlc16_throt_flesh_lab_inf_aug_12"] = true,
		["wh2_dlc16_throt_flesh_lab_inf_aug_13"] = true,
		["wh2_dlc16_throt_flesh_lab_inf_aug_14"] = true,
		["wh2_dlc16_throt_flesh_lab_inf_aug_15"] = true,
		["wh2_dlc16_throt_flesh_lab_inf_aug_16"] = true
	}, 
	["mon"] = {
		["wh2_dlc16_throt_flesh_lab_mon_aug_0"] = true,
		["wh2_dlc16_throt_flesh_lab_mon_aug_1"] = true,
		["wh2_dlc16_throt_flesh_lab_mon_aug_2"] = true,
		["wh2_dlc16_throt_flesh_lab_mon_aug_3"] = true,
		["wh2_dlc16_throt_flesh_lab_mon_aug_4"] = true,
		["wh2_dlc16_throt_flesh_lab_mon_aug_5"] = true,
		["wh2_dlc16_throt_flesh_lab_mon_aug_6"] = true,
		["wh2_dlc16_throt_flesh_lab_mon_aug_7"] = true,
		["wh2_dlc16_throt_flesh_lab_mon_aug_8"] = true,
		["wh2_dlc16_throt_flesh_lab_mon_aug_9"] = true,
		["wh2_dlc16_throt_flesh_lab_mon_aug_10"] = true,
		["wh2_dlc16_throt_flesh_lab_mon_aug_11"] = true,
		["wh2_dlc16_throt_flesh_lab_mon_aug_12"] = true,
		["wh2_dlc16_throt_flesh_lab_mon_aug_13"] = true,
		["wh2_dlc16_throt_flesh_lab_mon_aug_14"] = true,
		["wh2_dlc16_throt_flesh_lab_mon_aug_15"] = true,
		["wh2_dlc16_throt_flesh_lab_mon_aug_16"] = true
	}
}

local flesh_lab_instability_mutation_key = "wh2_dlc16_throt_flesh_lab_instability"
local flesh_lab_instability_protection_key = "wh2_dlc16_throt_flesh_lab_hidden_augment_instability_protection"
local flesh_lab_negative_mutation_list = {"wh2_dlc16_throt_flesh_lab_instability_1", "wh2_dlc16_throt_flesh_lab_instability_2", "wh2_dlc16_throt_flesh_lab_instability_3"}

local flesh_lab_growth_monster_key = "wh2_dlc16_throt_flesh_lab_monster"
local flesh_lab_upgrade_counter = 0
local flesh_lab_growth_max = 1000
local flesh_lab_growth_vat_natural_growth = 60
local flesh_lab_mutagen_degeneration = -20
local flesh_lab_mutagen_capacity = 100
local flesh_lab_monster_pack_events = {	
	"wh2_dlc16_skv_throt_flesh_lab_monster_supply_1a", 	-- 2 Wolf Rats, 2 Skavenslaves, 2 Skavenslave Spears
	"wh2_dlc16_skv_throt_flesh_lab_monster_supply_1b", 	-- 2 Wolf Rats, 1 Wolf Rats (Poison), 2 Skavenslaves
	"wh2_dlc16_skv_throt_flesh_lab_monster_supply_1c", 	-- 2 Wolf Rats, 1 Wolf Rats (Poison), 2 Skavenslave Spears
	"wh2_dlc16_skv_throt_flesh_lab_monster_supply_2a", 	-- 2 Rat Ogres, 1 Wolf Rats, 2 Skavenslaves, 2 Skavenslave Spears
	"wh2_dlc16_skv_throt_flesh_lab_monster_supply_2b", 	-- 3 Rat Ogres, 1 Wolf Rats, 2 Skavenslaves, 1 Skavenslave Spears
	"wh2_dlc16_skv_throt_flesh_lab_monster_supply_2c",	-- 3 Rat Ogres, 1 Wolf Rats, 2 Skavenslaves, 2 Skavenslave Spears
	"wh2_dlc16_skv_throt_flesh_lab_monster_supply_3a", 	-- 1 Brood Horror, 2 Wolf Rats, 2 Wolf Rats (Poison), 3 Skavenslaves
	"wh2_dlc16_skv_throt_flesh_lab_monster_supply_3b", 	-- 2 Brood Horror, 2 Wolf Rats, 2 Skavenslave Spears
	"wh2_dlc16_skv_throt_flesh_lab_monster_supply_3c", 	-- 2 Brood Horror, 2 Wolf Rats, 2 Skavenslaves, 2 Skavenslave Spears
	"wh2_dlc16_skv_throt_flesh_lab_monster_supply_4a", 	-- 1 Mutant Rat Ogre, 2 Rat Ogres, 1 Wolf Rats, 4 Skavenslave Spears
	"wh2_dlc16_skv_throt_flesh_lab_monster_supply_4b", 	-- 2 Mutant Rat Ogre, 2 Rat Ogres
	"wh2_dlc16_skv_throt_flesh_lab_monster_supply_4c", 	-- 2 Mutant Rat Ogre, 2 Rat Ogres, 2 Skavenslaves, 2 Skavenslave Spears
	"wh2_dlc16_skv_throt_flesh_lab_monster_supply_5a", 	-- 1 Hell Pit Abomination, 1 Brood Horror, 2 Rat Ogres, 4 Skavenslave Spears
	"wh2_dlc16_skv_throt_flesh_lab_monster_supply_5b", 	-- 1 Hell Pit Abomination, 1 Brood Horror, 3 Rat Ogres
	"wh2_dlc16_skv_throt_flesh_lab_monster_supply_5c"	-- 2 Hell Pit Abomination, 2 Rat Ogres, 4 Skavenslave Spears
}

local flesh_lab_monster_pack_event_index = {{}, {1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {10, 11, 12}, {13, 14, 15}}
local flesh_lab_monster_pack_threshold = {0.5, 0.65, 0.8, 0.9, 1, 1.2}
local flesh_lab_batch_notifier = false
local flesh_lab_mutagen_notifier = false

-- This is used for bespoke Flesh Lab upgrades
local flesh_lab_upgrade_ritual_keys = {	
	"wh2_dlc16_throt_flesh_lab_upgrade_0",
	"wh2_dlc16_throt_flesh_lab_upgrade_1",
	"wh2_dlc16_throt_flesh_lab_upgrade_2",
	"wh2_dlc16_throt_flesh_lab_upgrade_3",
	"wh2_dlc16_throt_flesh_lab_upgrade_4",
	"wh2_dlc16_throt_flesh_lab_upgrade_5",
	"wh2_dlc16_throt_flesh_lab_upgrade_6",
	"wh2_dlc16_throt_flesh_lab_upgrade_7",
	"wh2_dlc16_throt_flesh_lab_upgrade_8",
	"wh2_dlc16_throt_flesh_lab_upgrade_9"
}
local flesh_lab_upgrade_ritual_keys_tier1 = {	
	"wh2_dlc16_throt_flesh_lab_upgrade_0",
	"wh2_dlc16_throt_flesh_lab_upgrade_1",
	"wh2_dlc16_throt_flesh_lab_upgrade_2",
}
local flesh_lab_upgrade_ritual_keys_tier2 = {	
	"wh2_dlc16_throt_flesh_lab_upgrade_3",
	"wh2_dlc16_throt_flesh_lab_upgrade_4",
	"wh2_dlc16_throt_flesh_lab_upgrade_5",
}
local flesh_lab_upgrade_ritual_keys_tier3 = {	
	"wh2_dlc16_throt_flesh_lab_upgrade_6",
	"wh2_dlc16_throt_flesh_lab_upgrade_7",
	"wh2_dlc16_throt_flesh_lab_upgrade_8",
}

local flesh_lab_upgrade_purchased = {	
	["wh2_dlc16_throt_flesh_lab_upgrade_0"] = false,
	["wh2_dlc16_throt_flesh_lab_upgrade_1"] = false,
	["wh2_dlc16_throt_flesh_lab_upgrade_2"] = false,
	["wh2_dlc16_throt_flesh_lab_upgrade_3"] = false,
	["wh2_dlc16_throt_flesh_lab_upgrade_4"] = false,
	["wh2_dlc16_throt_flesh_lab_upgrade_5"] = false,
	["wh2_dlc16_throt_flesh_lab_upgrade_6"] = false,
	["wh2_dlc16_throt_flesh_lab_upgrade_7"] = false,
	["wh2_dlc16_throt_flesh_lab_upgrade_8"] = false,
	["wh2_dlc16_throt_flesh_lab_upgrade_9"] = false
}

-- this is to define the mutation template for AI based on units
-- notice you can add multiple combo for each unit record
local flesh_lab_AI_mutation_unit_index = {
	--infantry
	["wh2_main_skv_inf_clanrat_spearmen_0"] =	{1 ,2, 3},
	["wh2_main_skv_inf_clanrat_spearmen_1"] =	{1, 2, 3},
	["wh2_main_skv_inf_clanrats_0"] =			{1, 2, 3},
	["wh2_main_skv_inf_clanrats_1"] =			{1, 2, 3},
	["wh2_main_skv_inf_death_runners_0"] =		{1, 2, 3},
	["wh2_main_skv_inf_gutter_runners_0"] =		{1, 2, 3},
	["wh2_main_skv_inf_gutter_runners_1"] =		{1, 2, 3},
	["wh2_main_skv_inf_night_runners_0"] =		{1, 2, 3},
	["wh2_main_skv_inf_night_runners_1"] =		{1, 2, 3},
	--monsters
	["wh2_dlc16_skv_mon_brood_horror_0"] =		{4, 5, 6},
	["wh2_dlc16_skv_mon_rat_ogre_mutant"] =		{4, 5, 6},
	["wh2_dlc16_skv_mon_wolf_rats_0"] =			{4, 5, 6},
	["wh2_dlc16_skv_mon_wolf_rats_1"] =			{4, 5, 6},
	["wh2_main_skv_mon_hell_pit_abomination"] =	{4, 5, 6},
	["wh2_main_skv_mon_rat_ogres"] =			{4, 5, 6}
}
local flesh_lab_ai_mutation_combo = {
	--infantry combos
	{["wh2_dlc16_throt_flesh_lab_inf_aug_0"] = true, ["wh2_dlc16_throt_flesh_lab_inf_aug_2"] = true, ["wh2_dlc16_throt_flesh_lab_inf_aug_4"] = true, ["wh2_dlc16_throt_flesh_lab_inf_aug_8"] = true},
	{["wh2_dlc16_throt_flesh_lab_inf_aug_6"] = true, ["wh2_dlc16_throt_flesh_lab_inf_aug_10"] = true, ["wh2_dlc16_throt_flesh_lab_inf_aug_15"] = true},
	{["wh2_dlc16_throt_flesh_lab_inf_aug_9"] = true, ["wh2_dlc16_throt_flesh_lab_inf_aug_14"] = true, ["wh2_dlc16_throt_flesh_lab_inf_aug_16"] = true},
	--monster combos
	{["wh2_dlc16_throt_flesh_lab_mon_aug_6"] = true,["wh2_dlc16_throt_flesh_lab_mon_aug_8"] = true,["wh2_dlc16_throt_flesh_lab_mon_aug_11"] = true,["wh2_dlc16_throt_flesh_lab_mon_aug_14"] = true},
	{["wh2_dlc16_throt_flesh_lab_mon_aug_9"] = true,["wh2_dlc16_throt_flesh_lab_mon_aug_12"] = true,["wh2_dlc16_throt_flesh_lab_mon_aug_13"] = true,["wh2_dlc16_throt_flesh_lab_mon_aug_15"] = true},
	{["wh2_dlc16_throt_flesh_lab_mon_aug_7"] = true,["wh2_dlc16_throt_flesh_lab_mon_aug_14"] = true,["wh2_dlc16_throt_flesh_lab_mon_aug_15"] = true,["wh2_dlc16_throt_flesh_lab_mon_aug_16"] = true}
}
local flesh_lab_AI_check_cooldown = 20


function add_flesh_lab_listeners_skv()
	out("#### Adding Flesh Lab Listeners skv ####")
	
	-- set the current counter for the UI
	common.set_context_value("flesh_lab_upgrade_counter", flesh_lab_upgrade_counter)
	
	
	
	-- add 1 augment to each fresh unit coming from the mercenary pool
	local list_of_monster_augments = {
		"wh2_dlc16_throt_flesh_lab_mon_aug_0",
		"wh2_dlc16_throt_flesh_lab_mon_aug_1",
		"wh2_dlc16_throt_flesh_lab_mon_aug_2",
		"wh2_dlc16_throt_flesh_lab_mon_aug_3",
		"wh2_dlc16_throt_flesh_lab_mon_aug_5",
		"wh2_dlc16_throt_flesh_lab_mon_aug_6",
		"wh2_dlc16_throt_flesh_lab_mon_aug_7",
		"wh2_dlc16_throt_flesh_lab_mon_aug_8",
		"wh2_dlc16_throt_flesh_lab_mon_aug_9",
		"wh2_dlc16_throt_flesh_lab_mon_aug_10",
		"wh2_dlc16_throt_flesh_lab_mon_aug_11",
		"wh2_dlc16_throt_flesh_lab_mon_aug_12",
		"wh2_dlc16_throt_flesh_lab_mon_aug_13",
		"wh2_dlc16_throt_flesh_lab_mon_aug_14"
	}
	
	local list_of_infantry_augments = {
		"wh2_dlc16_throt_flesh_lab_inf_aug_0",
		"wh2_dlc16_throt_flesh_lab_inf_aug_1",
		"wh2_dlc16_throt_flesh_lab_inf_aug_2",
		"wh2_dlc16_throt_flesh_lab_inf_aug_3",
		"wh2_dlc16_throt_flesh_lab_inf_aug_6",
		"wh2_dlc16_throt_flesh_lab_inf_aug_7",
		"wh2_dlc16_throt_flesh_lab_inf_aug_8",
		"wh2_dlc16_throt_flesh_lab_inf_aug_9",
		"wh2_dlc16_throt_flesh_lab_inf_aug_10",
		"wh2_dlc16_throt_flesh_lab_inf_aug_11",
		"wh2_dlc16_throt_flesh_lab_inf_aug_12",
		"wh2_dlc16_throt_flesh_lab_inf_aug_13",
		"wh2_dlc16_throt_flesh_lab_inf_aug_14"
	}
	
	core:add_listener(
		"FleshLab_UnitTrained_skv",
		"UnitTrained", 
		function(context)
			local unit = context:unit()
			if not unit:is_null_interface() then
				local faction = unit:faction()
				return faction:name() == throt_faction_name and faction:is_human() and unit:unit_key():find("_flesh_lab")
			end
		end,
		function(context)
			local upgrades = 1
			
			if flesh_lab_upgrade_purchased["wh2_dlc16_throt_flesh_lab_upgrade_4"] then
				upgrades = 2
			end
			
			local list_of_possible_augments = {}
			
			local unit = context:unit()
			
			if unit:unit_key():find("skavenslave") then
				list_of_possible_augments = list_of_infantry_augments
			else
				list_of_possible_augments = list_of_monster_augments
			end
			
			local all_possible_augments = unit:get_unit_purchasable_effects()
			
			-- apply the Instability protection hidden augment then the random augments then remove instability protection
			for i = 0, all_possible_augments:num_items() - 1 do
				local effect_interface = all_possible_augments:item_at(i)
				
				if effect_interface:record_key() == flesh_lab_instability_protection_key then				
					cm:faction_purchase_unit_effect(unit:faction(), unit, effect_interface)
					random_mutation_application_skv(unit, upgrades, list_of_possible_augments)
					cm:faction_unpurchase_unit_effect(unit, effect_interface)
					break
				end
			end
		end,
		true
	)
	
	-- adds instability and negative mutations when condition is met
	core:add_listener(
		"Instability_CheckingAndApplying_skv",
		"UnitEffectPurchased",
		function(context)
			local unit = context:unit()
			
			if unit:faction():name() == throt_faction_name then
				local effect = context:effect():record_key()
				
				-- check if the purchased upgrade is the unit gaining Instability, or the script applying any hidden upgrades if so skip
				if effect:find("wh2_dlc16_throt_flesh_lab_instability") or effect:find("wh2_dlc16_throt_flesh_lab_hidden_augment_") then
					return
				end
				
				local purchased_effects = unit:get_unit_purchased_effects()
				
				-- if the unit has the Instability Protection hidden augment then skip
				for i = 0, purchased_effects:num_items() - 1 do
					if purchased_effects:item_at(i):record_key() == flesh_lab_instability_protection_key then
						return
					end
				end
				
				return true
			end
		end,
		function(context)
			local unit = context:unit()
			local effect = context:effect():record_key()
			local all_possible_augments = unit:get_unit_purchasable_effects()
			local instability_effect_interface = false
			local num_mutations = 0
			local can_instable = false
			local already_instable = false
			
			local num_augments = 0
			local list_of_augments = {}
			
			-- if one of the following 4 Augments has been purchased then apply the associated Random Augment reward
			if effect == "wh2_dlc16_throt_flesh_lab_mon_aug_4" then
				num_augments = 2 
				list_of_augments = {"wh2_dlc16_throt_flesh_lab_mon_aug_0", "wh2_dlc16_throt_flesh_lab_mon_aug_1", "wh2_dlc16_throt_flesh_lab_mon_aug_2", "wh2_dlc16_throt_flesh_lab_mon_aug_3", "wh2_dlc16_throt_flesh_lab_mon_aug_5", "wh2_dlc16_throt_flesh_lab_mon_aug_6", "wh2_dlc16_throt_flesh_lab_mon_aug_7"}
			elseif effect == "wh2_dlc16_throt_flesh_lab_mon_aug_16" then
				num_augments = 3 
				list_of_augments = {"wh2_dlc16_throt_flesh_lab_mon_aug_8", "wh2_dlc16_throt_flesh_lab_mon_aug_9", "wh2_dlc16_throt_flesh_lab_mon_aug_10", "wh2_dlc16_throt_flesh_lab_mon_aug_11", "wh2_dlc16_throt_flesh_lab_mon_aug_12", "wh2_dlc16_throt_flesh_lab_mon_aug_13", "wh2_dlc16_throt_flesh_lab_mon_aug_14"}
			elseif effect == "wh2_dlc16_throt_flesh_lab_inf_aug_5" then
				num_augments = 2 
				list_of_augments = {"wh2_dlc16_throt_flesh_lab_inf_aug_0", "wh2_dlc16_throt_flesh_lab_inf_aug_1", "wh2_dlc16_throt_flesh_lab_inf_aug_2", "wh2_dlc16_throt_flesh_lab_inf_aug_3", "wh2_dlc16_throt_flesh_lab_inf_aug_6", "wh2_dlc16_throt_flesh_lab_inf_aug_7"}
			elseif effect == "wh2_dlc16_throt_flesh_lab_inf_aug_17" then
				num_augments = 3 
				list_of_augments = {"wh2_dlc16_throt_flesh_lab_inf_aug_8", "wh2_dlc16_throt_flesh_lab_inf_aug_9", "wh2_dlc16_throt_flesh_lab_inf_aug_10", "wh2_dlc16_throt_flesh_lab_inf_aug_11", "wh2_dlc16_throt_flesh_lab_inf_aug_12", "wh2_dlc16_throt_flesh_lab_inf_aug_13", "wh2_dlc16_throt_flesh_lab_inf_aug_14"}
			end
			
			-- if it is one of the above 4 augments we protect the unit from instability rolls on the free random augments
			-- we do this because we only want the players unit to roll instability on the random augment itself, not the free augments that come with it
			if num_augments > 0 then
				-- apply the Instability protection hidden augment then the random augments then remove instability protection
				for i = 0, all_possible_augments:num_items() - 1 do
					local effect_interface = all_possible_augments:item_at(i)
					
					if effect_interface:record_key() == flesh_lab_instability_protection_key then				
						cm:faction_purchase_unit_effect(unit:faction(), unit, effect_interface)
						random_mutation_application_skv(unit, num_augments, list_of_augments)
						cm:faction_unpurchase_unit_effect(unit, effect_interface)
						break
					end
				end	
			end
			
			-- if the following Augment has been purchased rank up the selected unit (if possible)
			if effect == "wh2_dlc16_throt_flesh_lab_inf_aug_4" then
				cm:add_experience_to_unit(unit, 5)
			end
			
			local purchased_effects = unit:get_unit_purchased_effects()
			
			-- count the number of Mutations
			for i = 0, purchased_effects:num_items() - 1 do
				if purchased_effects:item_at(i):record_key() == flesh_lab_instability_mutation_key then
					already_instable = true
					break
				end
				
				if flesh_lab_mutation_list["inf"][effect] or flesh_lab_mutation_list["mon"][effect] then
					num_mutations = num_mutations + 1
				end
			end
			
			-- lab Upgrade Steroid Infusions - this gives units a ward save buff if they have 4+ Augments
			if num_mutations >= 4 then
				ward_save_upgrade_augment_application_skv(unit)
			end
			
			-- also check if the unit can have instability and get the effect interface if the unit can
			if already_instable then
				-- apply next stage of instability
				if cm:model():random_percent(50) then
					-- find out what the current highest level of Instability applied to the unit is
					local instability_level = get_instability_level_skv(unit)
					
					-- apply Instability if not already at tier 4
					if instability_level < 4 then
						for i = 0, all_possible_augments:num_items() - 1 do
							local current_effect = all_possible_augments:item_at(i)
							
							if current_effect:record_key() == flesh_lab_negative_mutation_list[instability_level] then
								instability_effect_interface = current_effect
								break
							end
						end
						
						-- the instability level was calculated before the next instability level was added so we add 1 more to the instability level if we were less than tier 4 already
						instability_level = instability_level + 1
						cm:faction_purchase_unit_effect(unit:faction(), unit, instability_effect_interface)
					end
					
					-- apply the augment to make the units upkeep reduced if it is instable, pass the instability level so we can apply the correct upkeep reduction amount
					upkeep_upgrade_augment_application_skv(unit, instability_level)
				end
			else
				for i = 0, all_possible_augments:num_items() - 1 do
					local current_effect = all_possible_augments:item_at(i)
					
					if current_effect:record_key() == flesh_lab_instability_mutation_key then
						instability_effect_interface = current_effect
						can_instable = true
						break
					end	
				end
				
				if can_instable then
					-- instability chance is the number of Augments * 10
					local chance = num_mutations * 10
					
					-- so the player is VERY unlikely to be unstable for the first couple of Augments, instead of 10% for first its now 5% and 10% for second, goes back to the regular chance after that
					if num_mutations <= 2 then
						chance = chance / 2
					end
					
					if cm:model():random_percent(chance) then
						-- adding Instability to unit
						cm:faction_purchase_unit_effect(unit:faction(), unit, instability_effect_interface)
						
						-- apply the augment to make the units upkeep reduced if it is instable, since it has only just become unstable its instability level must be 1
						upkeep_upgrade_augment_application_skv(unit, 1)
					end
				end
			end
		end,
		true
	)
	
	core:add_listener(
		"growth_vat_record_skv",
		"FactionTurnStart", 
		function(context)
			return context:faction():name() == throt_faction_name
		end,
		function(context)
			local faction = context:faction()
			local faction_is_human = faction:is_human()
			local faction_name = faction:name()
			
			-- unlock repeatable rituals
			if cm:model():turn_number() >= 2 then
				local list_of_repeatable_upgrades = {
					"wh2_dlc16_throt_flesh_lab_conversion",
					"wh2_dlc16_throt_flesh_lab_replenish",
					"wh2_dlc16_throt_flesh_lab_thrott"
				}
				
				for i = 1, #list_of_repeatable_upgrades do
					cm:unlock_ritual(faction, list_of_repeatable_upgrades[i])
				end
			end
			
			-- passive gain
			cm:faction_add_pooled_resource(faction_name, "skv_growth_vat", "wh2_dlc16_throt_flesh_lab_growth_vat_gain_passive_gain", flesh_lab_growth_vat_natural_growth)
			
			local current_value_growth = faction:pooled_resource_manager():resource("skv_growth_vat"):value();
			
			-- trigger incident to gift units to merc pool
			if faction_is_human and not flesh_lab_batch_notifier and current_value_growth > flesh_lab_growth_max * flesh_lab_monster_pack_threshold[1] then
				cm:trigger_incident(faction_name, "wh2_dlc16_skv_throt_flesh_lab_batch_available", true)
				flesh_lab_batch_notifier = true
			end
			
			-- set the current capacity for the UI
			common.set_context_value("mutagen_capacity", flesh_lab_mutagen_capacity)
			
			local current_value_mutagen = faction:pooled_resource_manager():resource("skv_mutagen"):value()
			
			-- mutagen capacity calculation bring it down to 100 (200 if upgraded)
			if current_value_mutagen > flesh_lab_mutagen_capacity then
				local flesh_lab_mutagen_degeneration_applied = (current_value_mutagen - flesh_lab_mutagen_capacity) * -1
				
				if flesh_lab_mutagen_degeneration_applied > flesh_lab_mutagen_degeneration then 
					cm:faction_add_pooled_resource(faction_name, "skv_mutagen", "wh2_dlc16_throt_flesh_lab_mutagen_used_degeneration", flesh_lab_mutagen_degeneration_applied)
				else
					cm:faction_add_pooled_resource(faction_name, "skv_mutagen", "wh2_dlc16_throt_flesh_lab_mutagen_used_degeneration", flesh_lab_mutagen_degeneration)
				end
				
				-- trigger incident to gift units to merc pool based on the random event choice from above
				if faction_is_human and not flesh_lab_mutagen_notifier then
					cm:trigger_incident(faction_name, "wh2_dlc16_skv_throt_flesh_lab_capacity_reached", true)
					flesh_lab_mutagen_notifier = true
				end
			end
			
			-- automatically release batch if growth vat hits 1000
			if current_value_growth > 999 then
				cm:perform_ritual(faction_name, "", flesh_lab_growth_monster_key)
			end
		end,
		true
	)
	
	-- handle the monster distribution by triggering incidents that distribute units to the merc pool
	core:add_listener(
		"growth_vat_monster_skv",
		"RitualCompletedEvent", 
		function(context)
			return context:performing_faction():name() == throt_faction_name and (context:ritual():ritual_key() == "wh2_dlc16_throt_flesh_lab_monster" or context:ritual():ritual_key() == "wh2_dlc16_throt_flesh_lab_monster_2")
		end,
		function(context)
			local faction = context:performing_faction()
			local current_value = faction:pooled_resource_manager():resource("skv_growth_vat"):value()
			
			-- safety check that the current_value isnt somehow lower than the first threshold, this should never happen!! (if UI works correctly then the Ritual button wont be available)
			if current_value >= flesh_lab_monster_pack_threshold[1] * flesh_lab_growth_max then
				-- start from 2 since we have already checked the first element previously
				for i = 2, #flesh_lab_monster_pack_threshold do
					-- set the current threshold by multiplying the maximum growth value by the threshold list entries (these are increments of 20% up to 120%)
					-- the 120% is used as the next check confirms your Growth Juice isnt above the the current threshold (it would be impossible to be above 120% of the limit)
					if current_value < flesh_lab_monster_pack_threshold[i] * flesh_lab_growth_max then
						local faction_name = faction:name()
						
						-- trigger incident to gift units to merc pool based on the random event choice from above
						cm:trigger_incident(faction_name, flesh_lab_monster_pack_events[flesh_lab_monster_pack_event_index[i][cm:random_number(#flesh_lab_monster_pack_event_index[i])]], true)
						
						-- reset Growth Juice in pooled resource
						cm:faction_add_pooled_resource(faction_name, "skv_growth_vat", "wh2_dlc16_throt_flesh_lab_growth_vat_lose_spawn_monster", -current_value)
						
						-- add additional extra unit to merc pool if upgrade has been unlocked
						if flesh_lab_upgrade_purchased["wh2_dlc16_throt_flesh_lab_upgrade_8"] then
							local additional_units = {
								"wh2_dlc16_skv_mon_brood_horror_0_flesh_lab",
								"wh2_dlc16_skv_mon_hell_pit_abomination_flesh_lab",
								"wh2_dlc16_skv_mon_rat_ogre_mutant_flesh_lab",
								"wh2_dlc16_skv_mon_rat_ogres_flesh_lab",
								"wh2_dlc16_skv_mon_wolf_rats_0_flesh_lab",
								"wh2_dlc16_skv_mon_wolf_rats_1_flesh_lab"
							}
							
							cm:add_units_to_faction_mercenary_pool(faction:command_queue_index(), additional_units[cm:random_number(#additional_units)], 1)
						end
						
						flesh_lab_batch_notifier = false
						flesh_lab_mutagen_notifier = false
						break
					end
				end
				
				-- count how many batches have been released
				flesh_lab_upgrade_counter = flesh_lab_upgrade_counter + 1
				
				-- set the current counter for the UI
				common.set_context_value("flesh_lab_upgrade_counter", flesh_lab_upgrade_counter)
				
				-- Unlock rituals based on tier
				if flesh_lab_upgrade_counter == 1 then
					for i = 1, #flesh_lab_upgrade_ritual_keys_tier1 do
						cm:unlock_ritual(faction, flesh_lab_upgrade_ritual_keys_tier1[i])
					end
				elseif flesh_lab_upgrade_counter == 4 then
					for i = 1, #flesh_lab_upgrade_ritual_keys_tier2 do
						cm:unlock_ritual(faction, flesh_lab_upgrade_ritual_keys_tier2[i])
					end
				elseif flesh_lab_upgrade_counter == 8 then
					for i = 1, #flesh_lab_upgrade_ritual_keys_tier3 do
						cm:unlock_ritual(faction, flesh_lab_upgrade_ritual_keys_tier3[i])
					end
				end
			else
				script_error("ERROR: Growth Vat Ritual completed but Growth Juice amount is less than the minimum to open VAT! How is this possible?")
			end
		end,
		true
	)
	
	-- Lab Upgrade Growth Catalysers adds a chance of generating food when recycling a unit
	core:add_listener(
		"flesh_lab_recycle_listerner_skv",
		"UnitDisbanded",
		function(context)
			local unit = context:unit()
			if not unit:is_null_interface() then
				local faction = unit:faction()
				return (faction:name() == throt_faction_name and faction:is_human()) 
			end
		end,
		function(context)
			local purchased_effects = context:unit():get_unit_purchased_effects() 
			
			for i = 0, purchased_effects:num_items() - 1 do
				if purchased_effects:item_at(i):record_key() == flesh_lab_instability_mutation_key then
					if true == flesh_lab_upgrade_purchased["wh2_dlc16_throt_flesh_lab_upgrade_4"] then
						cm:faction_add_pooled_resource(throt_faction_name, "skaven_food", "wh2_dlc16_resource_factor_food_throt_flesh_lab_positive", 5)
					end
					out("shy:add pool resource!");
					cm:faction_add_pooled_resource(throt_faction_name, "skv_growth_vat", "wh2_dlc16_throt_flesh_lab_growth_vat_gain_recycle", 50);
				end
			end
		end,
		true
	)
	
	-- check if a skavenslave is being recruited, also checks if Lab Upgrade is Purchased for the Random Augment application to Skavenslaves
	core:add_listener(
		"flesh_lab_recruitmen_listener_skv",
		"UnitTrained",
		function(context)
			local unit = context:unit()
			if not unit:is_null_interface() then
				local unit_key = unit:unit_key()
				local faction = unit:faction()
				return unit_key:find("skavenslave") and faction:name() == throt_faction_name and faction:is_human() and flesh_lab_upgrade_purchased["wh2_dlc16_throt_flesh_lab_upgrade_2"]
			end
		end,
		function(context)
			local unit = context:unit()
			
			local list_of_possible_augments = {
				"wh2_dlc16_throt_flesh_lab_inf_aug_0",
				"wh2_dlc16_throt_flesh_lab_inf_aug_1",
				"wh2_dlc16_throt_flesh_lab_inf_aug_2",
				"wh2_dlc16_throt_flesh_lab_inf_aug_3",
				"wh2_dlc16_throt_flesh_lab_inf_aug_6",
				"wh2_dlc16_throt_flesh_lab_inf_aug_7",
				"wh2_dlc16_throt_flesh_lab_inf_aug_8",
				"wh2_dlc16_throt_flesh_lab_inf_aug_9",
				"wh2_dlc16_throt_flesh_lab_inf_aug_10",
				"wh2_dlc16_throt_flesh_lab_inf_aug_11",
				"wh2_dlc16_throt_flesh_lab_inf_aug_12",
				"wh2_dlc16_throt_flesh_lab_inf_aug_13"
			}
			
			local num_augments = 1
			
			-- weighted roll between 1 and 4
			for i = 1, 4 do
				if cm:random_number(2) == 1 then
					num_augments = num_augments + 1
				end
			end
			
			random_mutation_application_skv(unit, num_augments, list_of_possible_augments)
			
			-- apply the augment to make the units no longer provide Growth Juice when Recycled
			local all_possible_augments = unit:get_unit_purchasable_effects()
			
			for i = 0, all_possible_augments:num_items() - 1 do
				local effect_interface = all_possible_augments:item_at(i)
				if effect_interface:record_key() == "wh2_dlc16_throt_flesh_lab_hidden_augment_refund_cancel" then
					cm:faction_purchase_unit_effect(unit:faction(), unit, effect_interface)
					break
				end	
			end
		end,
		true
	)
	
	-- apply effect bundle for feed throt repeatable action
	core:add_listener(
		"flesh_lab_monster_pack_listerner_skv",
		"RitualCompletedEvent",
		function(context)
			local faction = context:performing_faction()
			return faction:name() == throt_faction_name and faction:is_human() and context:ritual():ritual_key() == "wh2_dlc16_throt_flesh_lab_thrott"
		end,
		function(context)
			local faction = context:performing_faction()
			local faction_leader = faction:faction_leader()
			
			cm:remove_effect_bundle("wh2_dlc16_bundle_throt_flesh_lab_thrott_payload_dummy", faction:name())
			
			if faction_leader:has_military_force() then
				cm:apply_effect_bundle_to_character("wh2_dlc16_bundle_throt_flesh_lab_thrott_payload", faction_leader, 3)
			end
		end,
		true
	)
	
	-- apply any bespoke event based on lab upgrades and finish the corresponding scripted mission if active
	core:add_listener(
		"FleshLab_RitualCompletedEvent_skv",
		"RitualCompletedEvent",
		function(context)
			local faction = context:performing_faction()
			return faction:name() == throt_faction_name and faction:is_human() and flesh_lab_upgrade_purchased[context:ritual():ritual_key()] ~= nil
		end,
		function(context)
			flesh_lab_upgrade_purchased[context:ritual():ritual_key()] = true
			
			-- switch growth vat release ritual (increased skaven food)
			if flesh_lab_upgrade_purchased["wh2_dlc16_throt_flesh_lab_upgrade_3"] then
				flesh_lab_growth_monster_key = "wh2_dlc16_throt_flesh_lab_monster_2"
			end
			
			-- increase Mutagen capacity
			if flesh_lab_upgrade_purchased["wh2_dlc16_throt_flesh_lab_upgrade_5"] then
				flesh_lab_mutagen_capacity = 200
				common.set_context_value("mutagen_capacity", flesh_lab_mutagen_capacity)
			end
			
			local military_force_list = context:performing_faction():military_force_list()
							
			for i = 0, military_force_list:num_items() - 1 do
				local unit_list = military_force_list:item_at(i):unit_list()
				
				for j = 0, unit_list:num_items() - 1 do
					local unit = unit_list:item_at(j)
					local purchased_effects = unit:get_unit_purchased_effects()
					local num_mutations = 0 
					
					-- check if unit has Instability and count total number of Augments
					for k = 0, purchased_effects:num_items() - 1 do
						local effect = purchased_effects:item_at(k):record_key()
						
						-- unit has level one instability, no loop to see what the max level of instability the unit has
						if effect == flesh_lab_instability_mutation_key then
							upkeep_upgrade_augment_application_skv(unit, get_instability_level_skv(unit))
						end
						
						if flesh_lab_mutation_list["inf"][effect] or flesh_lab_mutation_list["mon"][effect] then
							num_mutations = num_mutations + 1
						end
					end
					
					-- Lab Upgrade Steroid Infusions gives units a ward save buff if they have 2+ Augments
					if num_mutations >= 4 then
						ward_save_upgrade_augment_application_skv(unit)
					end
					
					-- check if unit is a Skavenslaves or skavenslave spears unit
					local unit_key = unit:unit_key()
					
					if flesh_lab_upgrade_purchased["wh2_dlc16_throt_flesh_lab_upgrade_2"] and unit_key:find("skavenslave") then
						-- apply the augment to make the units no longer provide Growth Juice when Recycled
						local all_possible_augments = unit:get_unit_purchasable_effects()
						
						for l = 0, all_possible_augments:num_items() - 1 do
							local effect_interface = all_possible_augments:item_at(l)
							if effect_interface:record_key() == "wh2_dlc16_throt_flesh_lab_hidden_augment_refund_cancel" then
								cm:faction_purchase_unit_effect(unit:faction(), unit, effect_interface)
								break
							end
						end
					end
				end
			end
		end,
		true
	)
end

-- apply the augment to make the units upkeep reduced if it is instable
function upkeep_upgrade_augment_application_skv(unit, instability_level)
	if flesh_lab_upgrade_purchased["wh2_dlc16_throt_flesh_lab_upgrade_6"] then
		local upkeep_reduction_table = {
			"wh2_dlc16_throt_flesh_lab_hidden_augment_upkeep_reduction",
			"wh2_dlc16_throt_flesh_lab_hidden_augment_upkeep_reduction_2",
			"wh2_dlc16_throt_flesh_lab_hidden_augment_upkeep_reduction_3",
			"wh2_dlc16_throt_flesh_lab_hidden_augment_upkeep_removal"
		}
		
		local all_possible_augments = unit:get_unit_purchasable_effects()
		
		for i = 1, instability_level do
			for j = 0, all_possible_augments:num_items() - 1 do
				local effect_interface = all_possible_augments:item_at(j)
				
				if effect_interface:record_key() == upkeep_reduction_table[i] then				
					cm:faction_purchase_unit_effect(unit:faction(), unit, effect_interface)
					break
				end
			end
		end
	end
end

-- apply the augment to make the units weith 5+ Augments gain Ward save
function ward_save_upgrade_augment_application_skv(unit)
	if flesh_lab_upgrade_purchased["wh2_dlc16_throt_flesh_lab_upgrade_7"] then
		local all_possible_augments = unit:get_unit_purchasable_effects()
		
		for i = 0, all_possible_augments:num_items() - 1 do
			local effect_interface = all_possible_augments:item_at(i)
			
			if effect_interface:record_key() == "wh2_dlc16_throt_flesh_lab_hidden_augment_ward_save" then				
				cm:faction_purchase_unit_effect(unit:faction(), unit, effect_interface)
				break
			end
		end
	end
end

function random_mutation_application_skv(unit, number_of_augments, list_of_augments)
	local all_possible_augments = unit:get_unit_purchasable_effects()
	
	-- apply a hidden augment that makes all other augments free
	for i = 0, all_possible_augments:num_items() - 1 do
		local effect_interface = all_possible_augments:item_at(i)
		
		if effect_interface:record_key() == "wh2_dlc16_throt_flesh_lab_hidden_augment_cost_reduction" then
			cm:faction_purchase_unit_effect(unit:faction(), unit, effect_interface)
		end
	end
	
	local purchased_effects = unit:get_unit_purchased_effects()
	local existing_augments = {}
	
	-- loop through the list of possible Augments and create a list of Augments to apply
	for i = 0, purchased_effects:num_items() - 1 do
		local effect = purchased_effects:item_at(i):record_key()
		for j = 1, #list_of_augments do
			if effect == list_of_augments[j] then
				table.insert(existing_augments, list_of_augments[j])
			end
		end
	end
	
	-- remove the Augments already applied
	if next(existing_augments) ~= nil then
		for i = 1, #existing_augments do
			for j = 1, #list_of_augments do
				if existing_augments[i] == list_of_augments[j] then
					table.remove(list_of_augments, j)
				end
			end
		end
	end
	
	local num_augments_applied = 0
	
	-- if list of possible Augments is not empty then loop through possible Augments to randomly apply
	-- loop until number of augments applied is same as number of augments to apply
	while number_of_augments > num_augments_applied do
		if next(list_of_augments) ~= nil then
			local rnd = cm:random_number(#list_of_augments)
			local augment = list_of_augments[rnd]
			
			-- attempt to apply an Augment from the list
			for i = 0, all_possible_augments:num_items() - 1 do
				local effect_interface = all_possible_augments:item_at(i)
				
				if effect_interface:record_key() == augment then				
					cm:faction_purchase_unit_effect(unit:faction(), unit, effect_interface)
					break
				end	
			end
			
			-- update all existing augments now after attempting to apply another
			all_existing_augments = unit:get_unit_purchased_effects()
			
			-- check if Augment was applied
			for i = 0, all_existing_augments:num_items() - 1 do
				local effect_interface = all_existing_augments:item_at(i)
				
				if effect_interface:record_key() == augment then
					num_augments_applied = num_augments_applied + 1
					break
				end	
			end
			
			table.remove(list_of_augments, rnd)
		else
			out.design("\nNo more possible Augments to apply\n")
			num_augments_applied = number_of_augments
		end
	end
	
	-- remove the hidden augment that makes all other Augments free
	for i = 0, all_possible_augments:num_items() - 1 do
		local effect_interface = all_possible_augments:item_at(i)
		
		if effect_interface:record_key() == "wh2_dlc16_throt_flesh_lab_hidden_augment_cost_reduction" then				
			cm:faction_unpurchase_unit_effect(unit, effect_interface)
			break
		end
	end
	
	-- count how many mutations again because if the unit goes above 4 via a random augment upgrade it does not go through the count check in the Instability_CheckingAndApplying listener since the augment_cost_reduction is still present on unit
	local num_mutations = 0
	
	-- count the number of Mutations
	for i = 0, all_existing_augments:num_items() - 1 do
		local effect = all_existing_augments:item_at(i):record_key()
		
		if flesh_lab_mutation_list["inf"][effect] or flesh_lab_mutation_list["mon"][effect] then
			num_mutations = num_mutations + 1
		end
	end
	
	if num_mutations >= 4 then
		ward_save_upgrade_augment_application_skv(unit)
	end
end

-- returns the current instability level of a unit
function get_instability_level_skv(unit)
	local purchased_effects = unit:get_unit_purchased_effects()
	local instability_level = 1
	
	for i = 0, purchased_effects:num_items() - 1 do
		local effect = purchased_effects:item_at(i):record_key()
		
		if effect == flesh_lab_negative_mutation_list[1] and instability_level < 2 then
			instability_level = 2
		elseif effect == flesh_lab_negative_mutation_list[2] and instability_level < 3 then
			instability_level = 3
		elseif effect == flesh_lab_negative_mutation_list[3] then
			instability_level = 4
			break
		end
	end
	
	return instability_level
end

local function show_skv_flesh_lab_button(state)
	local ui_root = core:get_ui_root()
	out("shy0 show_flesh_lab_button print:")
	local ui_sotek =
		find_uicomponent(ui_root, "faction_buttons_docker", "button_group_management", "button_flesh_lab")
	out("shy0 show_flesh_lab_button print:1")
	if not ui_sotek then
		out("shy0 show_flesh_lab_button ERROR: button find failed!")
		return false
	end
	
	ui_sotek:SetVisible(state)
	
	ui_sotek = find_uicomponent(ui_root,"hud_campaign","growth_vat_bar_holder");
	if not ui_sotek then
		out("shy0 growth_vat_bar_holder ERROR: button find failed!")
		return false
	end
	ui_sotek:SetVisible(state)
	return true;
end

function add_unit_faction_mercenary_pool_expand_skv(faction_key, unit_key,num)
	out("shy add "..unit_key.." to "..faction_key);
	cm:add_unit_to_faction_mercenary_pool(
		cm:model():world():faction_by_key(faction_key),
		unit_key,
		"flesh_lab",
		num, -- unit count
		100, -- replenishment
		20, -- max_units
		0, -- max_units_replenished_per_turn
		"",
		"",
		"", -- restrictions
		true,
		unit_key
	);

	
end


function update_mercenary_pool(faction_name)
    add_unit_faction_mercenary_pool_expand_skv(faction_name,"wh2_dlc16_skv_inf_skavenslave_spearmen_0_flesh_lab",0);
    add_unit_faction_mercenary_pool_expand_skv(faction_name,"wh2_dlc16_skv_mon_wolf_rats_0_flesh_lab",0);
	add_unit_faction_mercenary_pool_expand_skv(faction_name,"wh2_dlc16_skv_inf_skavenslaves_0_flesh_lab",0);
    add_unit_faction_mercenary_pool_expand_skv(faction_name,"wh2_dlc16_skv_mon_wolf_rats_1_flesh_lab",0);
    add_unit_faction_mercenary_pool_expand_skv(faction_name,"wh2_dlc16_skv_mon_brood_horror_0_flesh_lab",0);
	add_unit_faction_mercenary_pool_expand_skv(faction_name,"wh2_dlc16_skv_mon_rat_ogres_flesh_lab",0);
	add_unit_faction_mercenary_pool_expand_skv(faction_name,"wh2_dlc16_skv_mon_hell_pit_abomination_flesh_lab",0);
    add_unit_faction_mercenary_pool_expand_skv(faction_name,"wh2_dlc16_skv_mon_rat_ogre_mutant_flesh_lab",0);
end

local function faction_is_skv(faction)
	if faction:is_null_interface() then
		return false;
	end

	local faction_subculture = faction:subculture();
	local is_skv = false;
	
	
	if faction_subculture ==  "wh2_main_sc_skv_skaven" then
		out("shy: is skv!");
		is_skv = true;
	end
	
	
	if is_skv == true then
		return true;
	else
		return false;
	end
end

local function hide_button_open_augment_skv()
	local button_parent = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "button_group_unit")

    if button_parent then       
		out("shy:found button 1");            
	--	button_parent:SetState("inactive");		
        local uic = find_uicomponent(button_parent, "button_open_augment");
        if uic then
			out("shy:found button 2");
            --uic:SetVisible(false);
			uic:SetState("inactive");
		--	uic:SetTooltipText("help is here", false);
        end
    end	 
    
end

function wh2_dlc16_flesh_lab_skv()
	local local_faction = cm:get_local_faction_name(true)
	out("wh2_dlc16_flesh_lab_skv:local_faction " .. local_faction)
	local script_belongs_faction = cm:model():world():faction_by_key(local_faction);
	if script_belongs_faction:culture() == "wh2_main_skv_skaven" and throt_faction_name ~= "" and local_faction == throt_faction_name then	
		show_skv_flesh_lab_button(true)
		add_flesh_lab_listeners_skv();
--        update_mercenary_pool(local_faction)
--		add_ritual_complete_listen_flesh_lab_sky()
--		core:remove_listener("AI_flesh_lab_listener")
	elseif
		script_belongs_faction:culture() == "wh2_main_skv_skaven" and throt_faction_name == "" and local_faction ~= throt_faction_key then
		show_skv_flesh_lab_button(false)
	end

	core:add_listener(
		"confederation_throt_skv_faction",
		"FactionJoinsConfederation",
		function(context)
			local faction_name = context:faction():name()
			out("throt:faction_name" .. faction_name)
			return faction_name == throt_faction_key
		end,
		function(context)
			local faction = context:confederation()			
			--   local confederation_faction = context:confederation();
			local confederation_name = context:confederation():name()
			out("throt:confederation_name" .. confederation_name)
			local faction_name_log = context:faction():name()
			out("throt:faction_name_log" .. faction_name_log)
			if faction:is_human() and throt_faction_name == "" then
				throt_faction_name = confederation_name;				
				show_skv_flesh_lab_button(true)
				add_flesh_lab_listeners_skv();
                update_mercenary_pool(throt_faction_name)
--				current_growth_vat_value = faction:pooled_resource("skv_growth_vat"):value()
--				add_ritual_complete_listen_flesh_lab_sky();
--				core:remove_listener("AI_flesh_lab_listener")
			else
				out("throt:fation is not hunman")
			end
		end,
		true
	)
    out("wh2_dlc16_flesh_lab_skv:local_faction 1" .. local_faction);
	core:add_listener(
				"HideSkvButtonOpenAugment",
				"ComponentLClickUp",
				function(context)
					out("shy skv:move on button is "..context.string);
--					print_all_uicomponent_children(core:get_ui_root());
            
					return throt_faction_name == "" ;
--					return not player_has_mouse_cursor_on_treasure_hunting_stance_button and context.string == "button_MILITARY_FORCE_ACTIVE_STANCE_TYPE_CHANNELING"
				end,
				function(context)
					-- player has placed the mouse cursor over the Dig for Treasure stance
					local script_belongs_to = cm:get_local_faction_name(true);
					out("shy:script_belongs_to "..script_belongs_to);	
					local is_skv = faction_is_skv(cm:model():world():faction_by_key(script_belongs_to));
					out("shy is skv faction is "..tostring(is_skv));
					if script_belongs_to and script_belongs_to ~= throt_faction_key and is_skv == true then																
						out("shy:find it");
						hide_button_open_augment_skv();
						--print_all_uicomponent_children(core:get_ui_root());									
						out("shy:not find!");								
					end
				end,
				true
			)
		core:add_listener(
		"real_timer_listener_skv",
		"RealTimeTrigger",
		true,
		function(context)
			if throt_faction_name == ""  then
				hide_button_open_augment_skv();
			end
		end,
		true
	);
     out("wh2_dlc16_flesh_lab_skv:local_faction 2" .. local_faction);
	
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("throt_faction_name", throt_faction_name, context)
		cm:save_named_value("flesh_lab_upgrade_purchased_skv", flesh_lab_upgrade_purchased, context)
		cm:save_named_value("flesh_lab_growth_monster_key_skv", flesh_lab_growth_monster_key, context)
		cm:save_named_value("flesh_lab_upgrade_counter_skv", flesh_lab_upgrade_counter, context)
		cm:save_named_value("flesh_lab_mutagen_capacity_skv", flesh_lab_mutagen_capacity, context)	
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			throt_faction_name = cm:load_named_value("throt_faction_name", "", context)
			flesh_lab_upgrade_purchased = cm:load_named_value("flesh_lab_upgrade_purchased_skv", flesh_lab_upgrade_purchased, context)
			flesh_lab_growth_monster_key = cm:load_named_value("flesh_lab_growth_monster_key_skv", flesh_lab_growth_monster_key, context)
			flesh_lab_upgrade_counter = cm:load_named_value("flesh_lab_upgrade_counter_skv", flesh_lab_upgrade_counter, context)
			flesh_lab_mutagen_capacity = cm:load_named_value("flesh_lab_mutagen_capacity_skv", flesh_lab_mutagen_capacity, context)
		end
	end
)