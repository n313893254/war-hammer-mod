

function ui_show_group_management_button(button_name,state)
		
	local ui_root = core:get_ui_root();	
	out("ui_show_group_management_button print:"..button_name);
	local ui_button = find_uicomponent(ui_root, "faction_buttons_docker", "button_group_management", button_name);
	out("ui_show_group_management_button print:1");
	if not ui_button then
        ui_button = find_uicomponent(ui_root, "hud_campaign", "faction_buttons_docker", button_name);
        if not ui_button then 
            out("ui find button failed:button_name:"..button_name);
            return false;	
        end;
			
	end;
    ui_button:SetVisible(state);	
end

function ui_show_resources_bar_holder_name(holder_name,state)
	local ui_root = core:get_ui_root();	
	out("ui_show_resources_bar_holder_name print:"..holder_name);
	local ui_sotek = find_uicomponent(ui_root,"hud_campaign","resources_bar_holder","resources_bar",holder_name);
	out("ui_show_resources_bar_holder_name print:1");
	if not ui_sotek then
		out("ui_show_resources_bar_holder_name ERROR: button find failed!")
		return false;
	end
	ui_sotek:SetVisible(state); 
--	ui_sotek:SetInteractive(state);
	return true;
end


function ui_show_resources_bar_icon(holder_name,button_name,state)
	local ui_root = core:get_ui_root();	
	out("ui_show_resources_bar_icon print:"..holder_name.."-"..button_name);
	local ui_sotek = find_uicomponent(ui_root,"hud_campaign","resources_bar_holder","resources_bar",holder_name,button_name);
	out("ui_show_resources_bar_icon print:1");
	if not ui_sotek then
		out("ui_show_resources_bar_icon ERROR: button find failed!")
		return false;
	end
	ui_sotek:SetVisible(state);  
--	ui_sotek:SetInteractive(state);
	return true;
end


function ui_show_resources_bar_icon_two(holder_name,button_name,icon_name,state)
	local ui_root = core:get_ui_root();	
	out("ui_show_resources_bar_icon_two print:"..holder_name.."-"..button_name.."-"..icon_name);
	local ui_sotek = find_uicomponent(ui_root,"hud_campaign","resources_bar_holder","resources_bar",holder_name,button_name,icon_name);
	out("ui_show_resources_bar_icon_two print:1");
	if not ui_sotek then
		out("ui_show_resources_bar_icon_two ERROR: button find failed!")
		return false;
	end
	ui_sotek:SetVisible(state); 
--	ui_sotek:SetInteractive(state);
	return true;
end

function chs_seduce_units(faction,local_faction)
	local faction_context = cm:model():world():faction_by_key(faction); 

	if not (cm:get_saved_value(faction .. "_enable_bribes_feature") or false) then
		cm:set_saved_value(faction .. "_enable_bribes_feature", true);
		cm:add_or_remove_faction_features(faction_context, {"bribery"}, true);		
		cm:trigger_incident(faction, "wh3_main_incident_dae_feature_slaanesh", true);
	else
        local effect_bundle = "wh3_main_bundle_seduce_units_bundles_1";
		if not faction_context:has_effect_bundle(effect_bundle) then
            cm:apply_effect_bundle(effect_bundle, faction, 0);
            return;
		end;
		effect_bundle = "wh3_main_bundle_seduce_units_bundles_2";
		if not faction_context:has_effect_bundle(effect_bundle) then
            cm:apply_effect_bundle(effect_bundle, faction, 0);
            return;
		end;
		effect_bundle = "wh3_main_bundle_seduce_units_bundles_3";
		if not faction_context:has_effect_bundle(effect_bundle) then
            cm:apply_effect_bundle(effect_bundle, faction, 0);
            return;
		end;
	end
end

function chs_enable_win_streaks_feature(faction,local_faction)
	local faction_context = cm:model():world():faction_by_key(faction); 
	if not (cm:get_saved_value(faction .. "_enable_win_streaks_feature") or false) then
       	cm:set_saved_value(faction .. "_enable_win_streaks_feature", true);
		cm:add_or_remove_faction_features(faction_context, {"streaks"}, true);		
		cm:trigger_incident(faction, "wh3_main_incident_dae_feature_khorne", true);	     
	end
end

function chs_enable_teleport_stance_feature(faction)
--	local faction_context = cm:model():world():faction_by_key(faction); 
	if cm:get_saved_value(faction .. "chs_enable_teleport_stance_feature") == false then
        common_enable_teleport_stance_feature(faction,true); 
		cm:set_saved_value(faction .. "chs_enable_teleport_stance_feature", true);		
		return;
	end	
	common_enable_teleport_stance_feature(faction,true); 
	cm:set_saved_value(faction .. "chs_enable_teleport_stance_feature", true);		
    
end

function chs_disable_teleport_stance_feature(faction)
--	local faction_context = cm:model():world():faction_by_key(faction); 
	if cm:get_saved_value(faction .. "chs_enable_teleport_stance_feature") == true then
        common_enable_teleport_stance_feature(faction,false); 
		cm:set_saved_value(faction .. "chs_enable_teleport_stance_feature", false);		
		
        return;
	end	
    common_enable_teleport_stance_feature(faction,false); 
	cm:set_saved_value(faction .. "chs_enable_teleport_stance_feature", false);
end


function common_enable_teleport_stance_feature(faction,state)
	local faction_context = cm:model():world():faction_by_key(faction);  
	if state == true then
        out("enable_teleport_stance_feature:"..faction);
        if faction_context:has_effect_bundle("wh2_dlc20_disable_teleport_stance_feature") then				
			cm:remove_effect_bundle("wh2_dlc20_disable_teleport_stance_feature", faction);	
		end; 
         
	else
        out("disable_teleport_stance_feature:"..faction);        
        if not faction_context:has_effect_bundle("wh2_dlc20_disable_teleport_stance_feature") then			
			cm:apply_effect_bundle("wh2_dlc20_disable_teleport_stance_feature", faction, 0);				
		end;
	end
		    
end

function faction_pool_resource_reinit(faction,resource_key,factor_key)
	local pooled_resource_manager = cm:get_faction(faction):pooled_resource_manager();
    local pool_resource_value = pooled_resource_manager:resource(resource_key):value();
    out("faction_pool_resource_add faction:"..faction.." resource_key:"..resource_key.." factor_key:"..factor_key.." resource value:"..tostring(pool_resource_value));
   
	if pool_resource_value > 0  then
        cm:faction_add_pooled_resource(faction, resource_key, factor_key, -pool_resource_value);
    end;
end

function wh1_main_common_function()
	out("wh1_main_common_function start");
	
    if cm:get_campaign_name() ~= "main_warhammer" then
            ui_show_resources_bar_holder_name("right_spacer_tomb_kings",false);
        
    end
end

