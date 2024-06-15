

local emp_subculture = "wh_main_sc_emp_empire";
local emp_gunnery_school_faction = "";
local emp_research_key = "wh3_dlc25_emp_research";
local emp_gunnery_school_owned_faction = "wh_main_emp_wissenland";
local emp_gunnery_school_factor_key = "other";

local fire_power_unit_list = {
    "wh2_dlc13_emp_art_mortar_ror_0",
    "wh2_dlc13_emp_inf_handgunners_ror_0",
    "wh2_dlc13_emp_veh_steam_tank_driver_ror_0",
    "wh2_dlc13_emp_veh_war_wagon_0",
    "wh2_dlc13_emp_veh_war_wagon_1",
    "wh2_dlc13_emp_veh_war_wagon_ror_0",
    "wh3_dlc25_emp_art_helstorm_rocket_battery_morr",
    "wh3_dlc25_emp_cav_outriders_morr",
    "wh3_dlc25_emp_cav_outriders_morr_blunderbusses",
    "wh3_dlc25_emp_cha_engineer",
    "wh3_dlc25_emp_cha_engineer_mechanical_steed",
    "wh3_dlc25_emp_cha_engineer_warhorse",
    "wh3_dlc25_emp_cha_master_engineer",
    "wh3_dlc25_emp_cha_master_engineer_mechanical_steed",
    "wh3_dlc25_emp_cha_master_engineer_steam_tank",
    "wh3_dlc25_emp_cha_master_engineer_warhorse",
    "wh3_dlc25_emp_inf_hochland_long_rifles",
    "wh3_dlc25_emp_inf_hochland_long_rifles_ror",
    "wh3_dlc25_emp_inf_nuln_ironsides",
    "wh3_dlc25_emp_inf_nuln_ironsides_morr",
    "wh3_dlc25_emp_inf_nuln_ironsides_morr_repeaters",
    "wh3_dlc25_emp_inf_nuln_ironsides_repeaters",
    "wh3_dlc25_emp_veh_marienburg_land_ship",
    "wh3_dlc25_emp_veh_marienburg_land_ship_morr",
    "wh3_dlc25_emp_veh_marienburg_land_ship_ror",
    "wh3_dlc25_emp_veh_steam_tank_volley_gun",
    "wh_dlc04_emp_art_hammer_of_the_witches_0",
    "wh_dlc04_emp_art_sunmaker_0",
    "wh_dlc04_emp_inf_flagellants_0",
    "wh_dlc04_emp_inf_free_company_militia_0",
    "wh_dlc04_emp_inf_silver_bullets_0",
    "wh_dlc04_emp_inf_stirlands_revenge_0",
    "wh_main_emp_art_great_cannon",
    "wh_main_emp_art_helblaster_volley_gun",
    "wh_main_emp_art_helstorm_rocket_battery",
    "wh_main_emp_art_mortar",
    "wh_main_emp_cav_outriders_0",
    "wh_main_emp_cav_outriders_1",
    "wh_main_emp_cav_pistoliers_1",
    "wh_main_emp_inf_handgunners",
    "wh_main_emp_veh_steam_tank_driver"
}

function find_unit_key_in_fire_power_unit_list(unit_key)
    for i = 1, #fire_power_unit_list do		
		if unit_key == fire_power_unit_list[i] then
			return true;
		end
	end
	return false;
end
--Initialise the counters for the different plague types
function emp_remove_gunnery_school_listeners()
	core:remove_listener("IEVictoryConditionShortVictoryGunnerySchool");
	core:remove_listener("VictoryConditionVictoryLongGunnerySchool");
end

function emp_get_mf_unit_art_num(mf_cqi)
    local art_num = 0;
    local attacker_force = cm:get_military_force_by_cqi(mf_cqi);
    if attacker_force then    
        local unit_list = attacker_force:unit_list();
        for i = 0, unit_list:num_items() - 1 do
            local unit = unit_list:item_at(i);
            if find_unit_key_in_fire_power_unit_list(unit:unit_key()) then
            art_num = art_num + 1;
            end
        end
    end
	return art_num;
end


function emp_gunnery_school_mission_relauch()
	for mission_key, _ in pairs(gunnery_school.artillery_mission_abilities) do
		--relaunch any active scripted artillery mission listeners after loading
		if cm:mission_is_active_for_faction(cm:get_faction(gunnery_school.faction_key), mission_key) then
			gunnery_school:scripted_artillery_mission_completion_listener(mission_key)
		end
	end
	core:add_listener(
		"emp_gain_research_FromBattle",
		"BattleCompleted",
		function(context)
			return cm:pending_battle_cache_faction_won_battle(emp_gunnery_school_faction)
		end,
		function(context)	
            local reseach_num = 0;
            local attcaker_num = cm:pending_battle_cache_num_attackers();
            local defender_num = cm:pending_battle_cache_num_defenders();
            if attcaker_num < 1 then
                return;
            end
            if defender_num < 1 then
                return;
            end
            local art_num = 0;
            local unit_num = 0;          
            
            if cm:pending_battle_cache_faction_is_attacker(emp_gunnery_school_faction) then
				for i = 1, attcaker_num do
                    local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(i); 				--Produces the list of attackers/defenders which oppose the faction which we want to log,
                    art_num = emp_get_mf_unit_art_num(mf_cqi);
                    out("emp_gain_research_FromBattle:"..tostring(i).."  faction_name:"..faction_name);                            
                end
                unit_num = defender_num;
			else
				for i = 1, defender_num do
                    local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i); 				--Produces the list of attackers/defenders which oppose the faction which we want to log,
                    art_num = emp_get_mf_unit_art_num(mf_cqi);
                    out("emp_gain_research_FromBattle:"..tostring(i).."  faction_name:"..faction_name);                            
                end
                unit_num = attcaker_num;
			end
            
            if art_num > 0 then
                out("art_num:"..art_num);
                reseach_num = cm:random_number(art_num*40,art_num*20);
				cm:faction_add_pooled_resource(emp_gunnery_school_faction, emp_research_key, "wh3_dlc25_gunnery_school_field_testing", reseach_num)
            end           
            
            
            if unit_num > 0 then
                out("unit_num:"..unit_num);
                reseach_num = cm:random_number(unit_num*40,unit_num*25);
				cm:faction_add_pooled_resource(emp_gunnery_school_faction, emp_research_key, "post_battle_options", reseach_num);
            end
		end,
		true
	)
end





cm:add_first_tick_callback(
	function()
		if emp_gunnery_school_faction ~= "" then
			gunnery_school.faction_key = emp_gunnery_school_faction;
			emp_remove_gunnery_school_listeners();
			gardens_of_morr.faction_key = emp_gunnery_school_faction;			
		end
	end
);


function show_gunnery_school_ui(state)
	ui_show_group_management_button("button_districts_of_nuln",state);
	ui_show_group_management_button("button_black_tower",state);
end



function wh3_dlc25_gunnery_school_emp_set_faction(faction,local_faction)
    if emp_gunnery_school_faction ~= "" then
       return;
    end;
	emp_gunnery_school_faction = faction;
	gunnery_school.faction_key = faction;
	gunnery_school.current_stage = 1;
	emp_gunnery_school_mission_relauch();
	gunnery_school:trigger_state_missions(1);
	emp_remove_gunnery_school_listeners();
	for unit, tooltip in pairs(gunnery_school.locked_states) do
		cm:add_unit_to_faction_mercenary_pool(
            cm:model():world():faction_by_key(gunnery_school.faction_key),
            unit,
            "renown",
            0, -- unit count
            0, -- replenishment
            20, -- max_units
            0, -- max_units_replenished_per_turn
            "",
            "",
            "", -- restrictions
            true,
            unit
        );
		cm:add_event_restricted_unit_record_for_faction(unit, gunnery_school.faction_key, tooltip)
	end
	gunnery_school:setup_incidents();
	
	gardens_of_morr.faction_key = faction;
	gardens_of_morr.current_regions = {};
	if cm:turn_number() >= 5 then
        cm:trigger_incident(gardens_of_morr.faction_key, gardens_of_morr.unlocked_incident, true)	
	end


	out("wh3_dlc25_gunnery_school_emp_set_faction:"..emp_gunnery_school_faction)
--    faction_pool_resource_reinit(faction,emp_research_key,emp_gunnery_school_factor_key)
	show_gunnery_school_ui(true);
	
end





function wh3_dlc25_gunnery_school_emp()
	out("wh3_dlc25_gunnery_school_emp start");
	local_faction = cm:get_local_faction_name(true);		
	out("wh3_dlc25_gunnery_school_emp:local_faction "..local_faction);
	local script_belongs_faction = cm:model():world():faction_by_key(local_faction);   
	
	local emp_faction_name = emp_gunnery_school_faction;
	if script_belongs_faction:subculture() == emp_subculture then
		if emp_faction_name ~= "" and local_faction == emp_faction_name then			
			gunnery_school.faction_key = emp_gunnery_school_faction;
			gardens_of_morr.faction_key = emp_gunnery_school_faction;
			emp_gunnery_school_mission_relauch();
			gunnery_school:setup_incidents();			
			show_gunnery_school_ui(true);			
		elseif emp_faction_name == "" and local_faction ~= emp_gunnery_school_owned_faction then          
    
			show_gunnery_school_ui(false);
			if cm:is_new_game() == true then
				cm:faction_add_pooled_resource(local_faction, emp_research_key, emp_gunnery_school_factor_key, -250);
			end		
		end	
	end

end


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("emp_gunnery_school_faction", emp_gunnery_school_faction, context)
--		cm:save_named_value("emp_wizard_cap", emp_wizard_cap, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			emp_gunnery_school_faction = cm:load_named_value("emp_gunnery_school_faction", emp_gunnery_school_faction, context)		
--			emp_wizard_cap = cm:load_named_value("emp_wizard_cap", emp_wizard_cap, context)				
		end
	end
)