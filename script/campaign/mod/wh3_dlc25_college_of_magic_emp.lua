

local emp_subculture = "wh_main_sc_emp_empire";
local emp_college_of_magic_faction = "";
local emp_arcane_essays_key = "wh3_dlc25_emp_arcane_essays";
local emp_college_of_magic_owned_faction = "wh2_dlc13_emp_golden_order";
local emp_college_of_magic_factor_key = "other";

--Initialise the counters for the different plague types

cm:add_first_tick_callback(
	function()
		if emp_college_of_magic_faction ~= "" then
			college_of_magic.faction_key = emp_college_of_magic_faction;
		end
	end
);


function show_college_of_magic_ui(state)
	ui_show_group_management_button("button_college_of_magic",state);
--	ui_show_resources_bar_holder_name("dy_nurgle_infections",state);
--	ui_show_resources_bar_icon("dy_nurgle_infections","nurgle_infections_icon",state);
--	ui_show_resources_bar_icon_two("ksl_spirit_essence_holder","dy_kislev_spirit_essence","kislev_spirit_essence_icon",state);
end


function emp_hide_unused_ui()
    local block = false;
    if  block == true then 
        return;
    end

     core:add_listener(
			"PanelOpenedCampaign_dlc25_college_of_magic",
			"PanelOpenedCampaign",
			function(context)                
				return context.string == "dlc25_college_of_magic";
			end,
			function(context)
                out("emp begin to hide ui!");
				local script_belongs_to = cm:get_local_faction_name(true);
				out("emp begin to hide ui:script_belongs_to "..script_belongs_to);				
                if emp_college_of_magic_faction ~= "" then
                     if script_belongs_to == emp_college_of_magic_faction then
                        local button_parent = find_uicomponent(core:get_ui_root(), "dlc25_college_of_magic", "category_group_list", "CcoRitualCategoryRecordEMPERORS_DECREES")
                        if button_parent then       
                            out("shy:found button CcoRitualCategoryRecordEMPERORS_DECREES");
                            --uic:SetVisible(false);
                            out("emp begin to hide ui find:"..button_parent:GetStateText())
                            out("emp begin to hide ui find tooltip:"..button_parent:GetTooltipText())
                            button_parent:SetVisible(false);
                            local button_child = find_uicomponent(core:get_ui_root(), "dlc25_college_of_magic", "category_group_list", "CcoRitualCategoryRecordCOM_METAL");
                            if button_child then
                                out("shy:found button CcoRitualCategoryRecordCOM_METAL");
                                button_child:SimulateLClick();
                            else
                                out("emp begin to hide ui CcoRitualCategoryRecordCOM_METAL not find")
                            end
                        else
                            out("emp begin to hide ui not find")
                        end	
                    end				
                end				
			end,
			true
		)	

end

function wh3_dlc25_college_of_magic_emp_set_faction(faction,local_faction)
    if emp_college_of_magic_faction ~= "" then
       return;
    end;
	emp_college_of_magic_faction = faction;
	college_of_magic.faction_key = faction;
	college_of_magic.wizard_cap.current_cap = 0;
	out("wh3_dlc25_college_of_magic_emp_set_faction:"..emp_college_of_magic_faction)
--    faction_pool_resource_reinit(faction,emp_arcane_essays_key,emp_college_of_magic_factor_key)
	show_college_of_magic_ui(true);
	emp_hide_unused_ui();
end





function wh3_dlc25_college_of_magic_emp()
	out("wh3_dlc25_college_of_magic_emp start");
	local_faction = cm:get_local_faction_name(true);		
	out("wh3_dlc25_college_of_magic_emp:local_faction "..local_faction);
	local script_belongs_faction = cm:model():world():faction_by_key(local_faction);   
	
	local emp_faction_name = emp_college_of_magic_faction;
	if script_belongs_faction:subculture() == emp_subculture then
		if emp_faction_name ~= "" and local_faction == emp_faction_name then		
				
			college_of_magic.faction_key = emp_college_of_magic_faction;
			show_college_of_magic_ui(true);
			emp_hide_unused_ui();
		elseif emp_faction_name == "" and local_faction ~= emp_college_of_magic_owned_faction then
            --faction_pool_resource_reinit(local_faction,emp_arcane_essays_key,emp_college_of_magic_factor_key);
    
			show_college_of_magic_ui(false);
			if cm:is_new_game() == true then
                cm:faction_add_pooled_resource(local_faction, emp_arcane_essays_key, emp_college_of_magic_factor_key, -150);
			end				
		end
	end
	
end


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("emp_college_of_magic_faction", emp_college_of_magic_faction, context)
--		cm:save_named_value("emp_wizard_cap", emp_wizard_cap, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			emp_college_of_magic_faction = cm:load_named_value("emp_college_of_magic_faction", emp_college_of_magic_faction, context)		
--			emp_wizard_cap = cm:load_named_value("emp_wizard_cap", emp_wizard_cap, context)				
		end
	end
)