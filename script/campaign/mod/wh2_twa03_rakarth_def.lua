local conf_def_faction_name = "";
local m_conf_rakarth_faction_key = "wh2_twa03_def_rakarth";

function setup_def_hunt_merc_pool()
	local rakarth_interface = cm:get_faction(RakarthBeastHunts.rakarth_faction_key)
	
	-- If the desired AI replenish rate is 75% chance of getting a beast each turn, but the sum chances are 100, then 100 / 75 = 0.75, so all chances are downscaled by this.
	for i, v in pairs(RakarthBeastHunts.ai_units) do
		cm:add_unit_to_faction_mercenary_pool(
			rakarth_interface,
			v[1], -- key
			v[2], -- recruitment source
			0, -- count
			0, --replen chance
			v[5], -- max units
			1, -- max per turn
			"",
			"",
			"",
			false,
			v[6] -- merc unit group
		)
        local fac_name = cm:get_local_faction_name(true);
--        cm:add_event_restricted_unit_record_for_faction(v[1], fac_name, "conf_def_rakarth_ror_lock");
	end	
end




function wh2_twa03_rakarth_def()
    local script_belongs_to = cm:get_local_faction_name(true);
	out("wh2_twa03_rakarth_def:script_belongs_to "..script_belongs_to);	
	local script_belongs_faction = cm:model():world():faction_by_key(script_belongs_to)
	if script_belongs_faction:culture() ==  "wh2_main_def_dark_elves" then
		if conf_def_faction_name == script_belongs_to then
			RakarthBeastHunts.rakarth_faction_key = conf_def_faction_name;
            setup_def_hunt_merc_pool();
			RakarthBeastHunts:setup_rakarth_listeners();	
		elseif script_belongs_to ~= m_conf_rakarth_faction_key then
			
		end
	end

	core:add_listener(
		"def_faction_joins_confederation",
		"FactionJoinsConfederation",
		function(context)
			local faction_name = context:faction():name();		
			out("shy:faction_name"..faction_name);
			return faction_name == m_conf_rakarth_faction_key;
		end,
		function(context)
			local faction = context:confederation();
			local confederation_name = context:confederation():name();
			out("shy:confederation_name"..confederation_name);
			local faction_name_log = context:faction():name();
			out("shy:faction_name_log"..faction_name_log);
			if faction:is_human() and conf_def_faction_name == "" then
				conf_def_faction_name = confederation_name;
				out("shy:conf_def_faction_name:"..conf_def_faction_name);	
				RakarthBeastHunts.rakarth_faction_key = conf_def_faction_name;
                setup_def_hunt_merc_pool();
				RakarthBeastHunts:setup_rakarth_listeners();
				
			else	
				out("shy:fation is not hunman");
			end;
		end,
		true
	);

end

----save/load

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("conf_def_faction_name", conf_def_faction_name, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			conf_def_faction_name = cm:load_named_value("conf_def_faction_name", "", context)
		end
	end
)