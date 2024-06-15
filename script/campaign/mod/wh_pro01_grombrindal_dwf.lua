local dwarf_faction_key = "";
local god_choice_dilemma_prefix = "wh_pro01_dwf_grombrindal_god_choice_";
local god_choice_last_god = "white_dwarf";
local god_choice_skill_key = "wh_pro01_skill_dwf_lord_unique_grombrindal_dilemma";
local god_choice_first_event = 3;
local turns_until_event = 25;
local dwarf_faction_name = "wh3_main_dwf_the_ancestral_throng"
function add_grombrindal_listeners_dwf()
	
	if cm:get_faction(dwarf_faction_key):is_human() then
		cm:add_faction_turn_start_listener_by_name(
			"Grombrindal_FactionTurnStart_dwf",
			dwarf_faction_key,
			function(context)
				local turn = cm:model():turn_number();
				turns_until_event = turns_until_event - 1;
				
				if turns_until_event <= 0 then
					trigger_god_choice_dwf();
					return;
				elseif turn == god_choice_first_event then -- first time the event triggers (turn 3)
					trigger_god_choice_dwf();
				end;
			end,
			true
		);
		
		core:add_listener(
			"Grombrindal_DilemmaChoiceMadeEvent_dwf",
			"DilemmaChoiceMadeEvent",
			function(context)
				return context:dilemma():starts_with(god_choice_dilemma_prefix);
			end,
			function(context)
				local choice = context:choice();
				
				if choice == 0 then
					god_choice_last_god = "grimnir";
				elseif choice == 1 then
					god_choice_last_god = "valaya";
				elseif choice == 2 then
					god_choice_last_god = "grungni";
				else
					god_choice_last_god = "white_dwarf";
				end;
				
				cm:remove_effect_bundle("wh_pro01_bundle_god_choice_none", dwarf_faction_key);
				give_grombrindal_effect_dwf();
			end,
			true
		);

		cm:add_faction_turn_start_listener_by_name(
			"Grombrindal_CharacterTurnStart_dwf",
			dwarf_faction_key,
			give_grombrindal_effect_dwf,
			true
		);
		
		core:add_listener(
			"Grombrindal_CharacterSkillPointAllocated_dwf",
			"CharacterSkillPointAllocated",
			function(context)
				return context:skill_point_spent_on() == god_choice_skill_key;
			end,
			function(context)
				remove_all_faction_god_bundles_dwf();
				
				turns_until_event = turns_until_event - 10;
				
				cm:apply_effect_bundle("wh_pro01_bundle_god_choice_" .. god_choice_last_god, dwarf_faction_key, turns_until_event);
				
				if turns_until_event <= 0 then
					trigger_god_choice_dwf();
				end;
			end,
			true
		);
		
		if cm:is_new_game() then
			cm:apply_effect_bundle("wh_pro01_bundle_god_choice_none", dwarf_faction_key, god_choice_first_event);
		end;
	end;
end;

function remove_all_faction_god_bundles_dwf()
	local bundles = {
		"wh_pro01_bundle_god_choice_none",
		"wh_pro01_bundle_god_choice_grimnir",
		"wh_pro01_bundle_god_choice_grungni",
		"wh_pro01_bundle_god_choice_valaya",
		"wh_pro01_bundle_god_choice_white_dwarf"
	};
	
	for i = 1, #bundles do
		cm:remove_effect_bundle(bundles[i], dwarf_faction_key);
	end;
end;

function trigger_god_choice_dwf()
	remove_all_faction_god_bundles_dwf();
	cm:apply_effect_bundle("wh_pro01_bundle_god_choice_none", dwarf_faction_key, 0);
	
	-- reset the timer 
	turns_until_event = 25;
	
	local grombrindal = get_grombrindal_dwf();
	
	if grombrindal then
		if grombrindal:has_skill(god_choice_skill_key) then
			turns_until_event = 15;
		end;
	end;
	
	local dilemma = god_choice_dilemma_prefix .. god_choice_last_god .. "_" .. tostring(turns_until_event);
	
	out("GOD DILEMMA - Triggering God Dilemma [" .. dilemma .. "]");
	cm:trigger_dilemma(dwarf_faction_key, dilemma);
end;

function give_grombrindal_effect_dwf()
	local effect = "wh_pro01_bundle_god_choice_" .. god_choice_last_god .. "_force";
	
	if god_choice_last_god ~= "none" and cm:model():turn_number() > 2 then
		local character = get_grombrindal_dwf();
		
		local faction = cm:get_faction(dwarf_faction_key);
		
		if faction and character then
			local cqi = character:command_queue_index();
			
			local bundles = {
				"wh_pro01_bundle_god_choice_grimnir_force",
				"wh_pro01_bundle_god_choice_grungni_force",
				"wh_pro01_bundle_god_choice_valaya_force",
				"wh_pro01_bundle_god_choice_white_dwarf_force"
			};
			
			for i = 1, #bundles do
				cm:remove_effect_bundle_from_characters_force(bundles[i], cqi);
			end;
			
			if character:get_forename() == "names_name_2147358917" and character:has_military_force() then
				cm:apply_effect_bundle_to_characters_force(effect, cqi, 0);
			end;
		end;
	end;
end;

function get_grombrindal_dwf()
	local faction = cm:get_faction(dwarf_faction_key);
	
	if faction then
		local character_list = faction:character_list();
		
		for i = 0, character_list:num_items() - 1 do
			local current_char = character_list:item_at(i);
			
			if current_char:get_forename() == "names_name_2147358917" then
				return current_char;
			end;
		end;
	end;
end;

local function show_grombrindal_dwf_holder(state)
		
	local ui_root = core:get_ui_root();	
	out("shy1 show_grombrindal_dwf_holder print:");
	local ui_sotek = find_uicomponent(ui_root,"hud_campaign","right_spacer_grombrindal");
	out("shy1 show_grombrindal_dwf_holder print:1");
	if not ui_sotek then
	out("shy1 show_grombrindal_dwf_holder ERROR: button find failed!");	
		return false;	
	end;		
	
	ui_sotek:SetVisible(state);		
	
end


function wh_pro01_grombrindal_dwf()
	
	
	local local_faction = cm:get_local_faction_name(true);		
	out("wh_pro01_grombrindal_dwf:local_faction "..local_faction);
	local script_belongs_faction = cm:model():world():faction_by_key(local_faction);   
	
    
	if dwarf_faction_key ~= "" and local_faction == dwarf_faction_key then		
		show_grombrindal_dwf_holder(true);
        add_grombrindal_listeners_dwf();
	end	

	
	core:add_listener(
		"confederation_dwf_the_ancestral_throng_faction",
		"FactionJoinsConfederation",
		function(context)
			local faction_name = context:faction():name();
			out("dwf:faction_name"..faction_name);
			return faction_name == dwarf_faction_name;
		end,
		function(context)
			local faction = context:confederation();
         --   local confederation_faction = context:confederation();
			local confederation_name = context:confederation():name();
			out("dwf:confederation_name"..confederation_name);
			local faction_name_log = context:faction():name();
			out("dwf:faction_name_log"..faction_name_log);
			if faction:is_human() and dwarf_faction_key == "" then
				dwarf_faction_key = confederation_name;
				show_grombrindal_dwf_holder(true);
                add_grombrindal_listeners_dwf();
                cm:apply_effect_bundle("wh_pro01_bundle_god_choice_none", dwarf_faction_key, god_choice_first_event);
				god_choice_first_event = cm:model():turn_number() + 2	
			else
				out("dwf:fation is not hunman");
			end;
		end,
		true
	);

end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("god_choice_first_event", god_choice_first_event, context);
		cm:save_named_value("dwarf_faction_key", dwarf_faction_key, context);
		cm:save_named_value("GOD_CHOICE_LAST_GOD_dwf", god_choice_last_god, context);
		cm:save_named_value("turns_until_event_dwf", turns_until_event, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		dwarf_faction_key = cm:load_named_value("dwarf_faction_key", "", context);
		god_choice_first_event = cm:load_named_value("god_choice_first_event", god_choice_first_event, context);
		god_choice_last_god = cm:load_named_value("GOD_CHOICE_LAST_GOD_dwf", "white_dwarf", context);
		turns_until_event = cm:load_named_value("turns_until_event_dwf", 25, context);
	end
);