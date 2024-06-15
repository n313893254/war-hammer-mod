local m_dwf_conf_thorek = ""
local m_conf_thorek_faction = "wh2_dlc17_dwf_thorek_ironbrow"
local function enable_dwf_artifact_vault(is_enable)
			
	if is_enable == true and m_dwf_conf_thorek ~= ""  then	
		local enable_faction = cm:model():world():faction_by_key(m_dwf_conf_thorek);
		if enable_faction:has_effect_bundle("wh2_dlc17_disable_artifact_vault") then							
			cm:remove_effect_bundle("wh2_dlc17_disable_artifact_vault", m_dwf_conf_thorek);
							
		end;
		if not enable_faction:has_effect_bundle("wh2_dlc17_enable_artifact_vault") then							
			cm:apply_effect_bundle("wh2_dlc17_enable_artifact_vault", m_dwf_conf_thorek, -1);								
		end;
			
	else
		local script_belongs_to = cm:get_local_faction_name(true);
		local enable_faction = cm:model():world():faction_by_key(script_belongs_to);
		if not enable_faction:has_effect_bundle("wh2_dlc17_disable_artifact_vault") then			
			cm:apply_effect_bundle("wh2_dlc17_disable_artifact_vault", script_belongs_to, -1);							
		end;
		if enable_faction:has_effect_bundle("wh2_dlc17_enable_artifact_vault") then							
			cm:remove_effect_bundle("wh2_dlc17_enable_artifact_vault", script_belongs_to);							
		end;
	end	
end

function apply_region_vfx_dwf()
	
	for artifact_key, artifact_part_info in pairs(thorek.artifact_parts) do
			local region_key = artifact_part_info.region
			
			cm:add_garrison_residence_vfx(cm:get_region(region_key):garrison_residence():command_queue_index(), thorek.artifact_piece_vfx_key, true)
			-- also applys effect bundle to display artefact part icon on region
	--		cm:apply_effect_bundle_to_region(artifact_part_info.bundle, region_key, 0)
	end
end

function refresh_all_ritual_list_dwf(faction)
            
    local region_list = faction:region_list();
	for i = 0, region_list:num_items() - 1 do
        local region = region_list:item_at(i);
        local region_key = region:name();
        local artifact_part_key = thorek:get_artifact_part_from_region(region_key);

		if artifact_part_key then
			local owner = region:owning_faction();
			if (owner:name() == thorek.thorek_faction_key or owner:is_ally_vassal_or_client_state_of(cm:get_faction(thorek.thorek_faction_key))) then
				thorek:award_artifact_part(artifact_part_key, 1);
				
				cm:remove_garrison_residence_vfx(region:garrison_residence():command_queue_index(), thorek.artifact_piece_vfx_key);
			end
			if not thorek.already_looted[artifact_part_key] then
				cm:apply_effect_bundle_to_region(thorek.artifact_parts[artifact_part_key].bundle, region_key, 0)
			end			
		end
	end
end
function wh2_dlc17_thorek_dwf()
	
	local script_belongs_to = cm:get_local_faction_name(true);
	out("shy:script_belongs_to "..script_belongs_to);	
	local script_belongs_faction = cm:model():world():faction_by_key(script_belongs_to)
	if script_belongs_faction:culture() ==  "wh_main_dwf_dwarfs" then
		if m_dwf_conf_thorek == script_belongs_to then
			thorek.thorek_faction_key = m_dwf_conf_thorek;
			enable_dwf_artifact_vault(true)
			thorek:initialise();
			if not cm:is_new_game() then
				apply_region_vfx_dwf();
			end
            refresh_all_ritual_list_dwf(script_belongs_faction);			
		elseif script_belongs_to ~= m_conf_thorek_faction then
			enable_dwf_artifact_vault(false)
		end
	end

	core:add_listener(
		"dwf_faction_joins_confederation",
		"FactionJoinsConfederation",
		function(context)
			local faction_name = context:faction():name();		
			out("shy:faction_name"..faction_name);
			return faction_name == m_conf_thorek_faction;
		end,
		function(context)
			local faction = context:confederation();
			local confederation_name = context:confederation():name();
			out("shy:confederation_name"..confederation_name);
			local faction_name_log = context:faction():name();
			out("shy:faction_name_log"..faction_name_log);
			if faction:is_human() and m_dwf_conf_thorek == "" then
				m_dwf_conf_thorek = confederation_name;
				out("shy:m_dwf_conf_thorek:"..m_dwf_conf_thorek);	
				thorek.thorek_faction_key = m_dwf_conf_thorek;
				enable_dwf_artifact_vault(true);	
				thorek:initialise();
				if not cm:is_new_game() then
					apply_region_vfx_dwf();
				end
                refresh_all_ritual_list_dwf(faction);
				
			else	
				out("shy:fation is not hunman");
			end;
		end,
		true
	);
    core:add_listener(
		"thorek_crafting_ritual",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_category() == "CRAFTING_RITUAL";
		end,
		function(context)
			local ritual = context:ritual();
			local ritual_key = ritual:ritual_key();
			local faction = context:performing_faction();
			local faction_cqi = context:performing_faction():command_queue_index()
			local faction_name = faction:name();
			
			--Any rituals beginning with this prefix will be considered a thorek artifact ritual.
			local ritual_prefix = "wh2_dlc17_dwf_ritual_thorek_artifact_1"
			
			
			if faction_name == m_dwf_conf_thorek and ritual_key == ritual_prefix then
				cm:add_unit_to_faction_mercenary_pool(
                    cm:model():world():faction_by_key(m_dwf_conf_thorek),
                    "wh2_dlc17_dwf_mon_carnosaur_thorek_0",
					"renown",
                    1, -- unit count
                    100, -- replenishment
                    1, -- max_units
                    0.10, -- max_units_replenished_per_turn
                    "",
                    "",
                    "", -- restrictions
                    true,
					"wh2_dlc17_dwf_mon_carnosaur_thorek_0"
                );
			end	
		end,
		true
	);
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
    function(context)		
		cm:save_named_value("dwf_conf_thorek", m_dwf_conf_thorek, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then            
			m_dwf_conf_thorek = cm:load_named_value("dwf_conf_thorek", "", context)
		end
	end
)