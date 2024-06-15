local chs_nurgle_plagues_faction = "";
local chs_nurgle_epidemius_faction = "";
local chs_nurgle_epidemius_owned_faction = "wh3_dlc25_nur_epidemius";
local nur_subculture = "wh3_main_sc_nur_nurgle";

local chs_nur_infections_key = "wh3_main_nur_infections";
local chs_nurgle_owned_faction = "wh3_dlc20_chs_festus";
local nurgle_plagues_factor_key = "plague_creation";
local chs_subculture = "wh_main_sc_chs_chaos";
--Initialise the counters for the different plague types


cm:add_first_tick_callback(
	function()
        if chs_nurgle_plagues_faction ~= "" then
            nurgle_plagues.festus_faction = chs_nurgle_plagues_faction;            
        end;
         if chs_nurgle_epidemius_faction ~= "" then
            nurgle_plagues.epidemius_faction = chs_nurgle_epidemius_faction;            
        end;
	end
);


function show_chs_nurgle_plagues_ui(state)
	ui_show_group_management_button("button_nurgle_plagues",state);

end

function show_chs_nurgle_epidemius_ui(state)
	ui_show_resources_bar_holder_name("epidemius_tally_holder",state);

end


function wh3_campaign_nur_epidemius_chs_set_faction(faction,local_faction)
    if chs_nurgle_epidemius_faction ~= "" then
       return;
    end;
    out("wh3_campaign_nur_epidemius_chs_set_faction start");
	chs_nurgle_epidemius_faction = faction;
	nurgle_plagues.epidemius_faction = faction;	
   
	out("wh3_campaign_nurgle_plagues_chs_set_faction:"..chs_nurgle_plagues_faction)
	show_chs_nurgle_epidemius_ui(true);

end

function wh3_campaign_nurgle_plagues_chs_set_faction(faction,local_faction)
    if chs_nurgle_plagues_faction ~= "" then
       return;
    end;
    out("wh3_campaign_nurgle_plagues_chs_set_faction start");
	chs_nurgle_plagues_faction = faction;
	nurgle_plagues.festus_faction = faction;
	nurgle_plagues.plague_faction_info[faction] = {max_blessed_symptoms = 1, current_symptoms_list = {}, plague_creation_counter = 3};
        nurgle_plagues.plague_button_unlock[faction] = {button_locked = true, infections_gained = 0, infections_end_of_last_turn = 200};
	out("nurgle_plagues.plague_button_unlock start");
	for k,v in pairs(nurgle_plagues.plague_button_unlock) do 
        out(k.."--"..nurgle_plagues.plague_button_unlock[k].infections_end_of_last_turn);
    end
	
	local pfi = nurgle_plagues.plague_faction_info;
	local faction_name = faction;
	local faction_info = pfi[faction_name];
    if faction_info ~= nil then
        faction_info.current_symptoms_list = nurgle_plagues:copy_symptom_table()

        if chs_nurgle_owned_faction == local_faction then
            nurgle_plagues:festus_symptom_swap(faction_info)
        end

        if cm:model():world():faction_by_key(faction_name):is_human() then
            nurgle_plagues:toggle_plagues_button(cm:model():world():faction_by_key(faction_name), nurgle_plagues.plague_button_unlock[faction_name], true, false)
        end
					
        common.set_context_value("random_plague_component_list_" .. faction_name, faction_info.current_symptoms_list)
        common.set_context_value("random_plague_creation_count_" .. faction_name, faction_info.plague_creation_counter)

        cm:set_plague_component_state(cm:model():world():faction_by_key(faction_name), nurgle_plagues.starting_symptom_key, "UNLOCKED", true)
        cm:set_plague_component_state(cm:model():world():faction_by_key(faction_name), nurgle_plagues.starting_blessed_symptom_key, "BLESSED", true)
        
        
    end

	out("wh3_campaign_nurgle_plagues_chs_set_faction:"..chs_nurgle_plagues_faction)

	show_chs_nurgle_plagues_ui(true);
	chs_eyes_of_god_table_add(faction,local_faction);
	chs_eyes_of_god_reinit();
end





function wh3_campaign_nurgle_plagues_chs()
	out("wh3_campaign_nurgle_plagues_chs start");
	local_faction = cm:get_local_faction_name(true);		
	out("wh3_campaign_nurgle_plagues_chs:local_faction "..local_faction);
	local script_belongs_faction = cm:model():world():faction_by_key(local_faction);   
	local chs_subculture = "wh_main_sc_chs_chaos";
	local chs_faction_name = chs_nurgle_plagues_faction;
	if script_belongs_faction:subculture() == chs_subculture then
		if chs_faction_name ~= "" and local_faction == chs_faction_name then
            nurgle_plagues.festus_faction = chs_faction_name;
			show_chs_nurgle_plagues_ui(true);
			
		elseif chs_faction_name == "" and local_faction ~= chs_nurgle_owned_faction then

			show_chs_nurgle_plagues_ui(false);	
		end	
	end
	chs_faction_name = chs_nurgle_epidemius_faction;
	if script_belongs_faction:subculture() == nur_subculture then
		if chs_faction_name ~= "" and local_faction == chs_faction_name then
            nurgle_plagues.epidemius_faction = chs_faction_name;	
			show_chs_nurgle_epidemius_ui(true);
			
		elseif chs_faction_name == "" and local_faction ~= chs_nurgle_epidemius_owned_faction then   
			show_chs_nurgle_epidemius_ui(false);
			
		end	
	end

	
end


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("chs_nurgle_plagues_faction", chs_nurgle_plagues_faction, context)
		cm:save_named_value("chs_nurgle_epidemius_faction", chs_nurgle_epidemius_faction, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			chs_nurgle_plagues_faction = cm:load_named_value("chs_nurgle_plagues_faction", chs_nurgle_plagues_faction, context)		
			chs_nurgle_epidemius_faction = cm:load_named_value("chs_nurgle_epidemius_faction", chs_nurgle_epidemius_faction, context)				
		end
	end
)