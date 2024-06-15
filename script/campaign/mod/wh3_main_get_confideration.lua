
confideration_faction_callback = { 
			["wh3_dlc24_ksl_daughters_of_the_forest"] = wh3_dlc24_mother_ostankya_ksl_set_faction,
			["wh3_dlc20_chs_sigvald"] = chs_sigvald_faction_trait_set_faction,
			["wh3_dlc20_chs_azazel"] = chs_azazel_faction_trait_set_faction,
			["wh3_dlc20_chs_festus"] = wh3_campaign_nurgle_plagues_chs_set_faction,
			["wh3_dlc20_chs_valkia"] = chs_valkia_faction_trait_set_faction,
			["wh3_dlc20_chs_vilitch"] = chs_vilitch_faction_trait_set_faction,
			["wh3_main_chs_shadow_legion"] = chs_shadow_legion_faction_trait_set_faction,
			["wh3_dlc24_cth_the_celestial_court"] = cth_the_celestial_court_faction_trait_set_faction,
			["wh2_dlc13_emp_golden_order"] = wh3_dlc25_college_of_magic_emp_set_faction,
			["wh_main_emp_wissenland"] = wh3_dlc25_gunnery_school_emp_set_faction,
			["wh3_dlc25_dwf_malakai"] = wh3_dlc25_malakai_battles_dwf_set_faction,
			["wh3_dlc25_nur_epidemius"] = wh3_campaign_nur_epidemius_chs_set_faction

			
		};


function wh3_main_get_confideration()
	out("wh3_main_get_confideration start");
	core:add_listener(
		"confederation_task_get_faction",
		"FactionJoinsConfederation",
		function(context)
			local faction_name = context:faction():name();
			out("wh3_main_get_confideration:faction_name"..faction_name);
			return confideration_faction_callback[faction_name] ~= nil;
		end,
		function(context)
			local faction = context:confederation();
         --   local confederation_faction = context:confederation();
			local confederation_name = context:confederation():name();
			out("wh3_main_get_confideration:confederation_name"..confederation_name);
			local faction_name_log = context:faction():name();
			out("wh3_main_get_confideration:faction_name_log"..faction_name_log);
			if faction:is_human() then
				confideration_faction_callback[faction_name_log](confederation_name,faction_name_log);		
			else
				out("wh3_main_get_confideration:fation is not hunman");
			end;
		end,
		true
	);
	
end

