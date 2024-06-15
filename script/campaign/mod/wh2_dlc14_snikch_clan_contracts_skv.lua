local contract_faction = "";
local contract_faction_skv = "wh2_main_skv_clan_eshin";
local dust_is_new_ganme = true;
local contract_clans = {
	{key = "mors", level = 1, last_contract = 0},
	{key = "moulder", level = 1, last_contract = 0},
	{key = "pestilens", level = 1, last_contract = 0},
	{key = "skryre", level = 1, last_contract = 0}
};
local contract_ritual_categories = {
	"ESHIN_MORS_RITUAL",
	"ESHIN_MOULDER_RITUAL",
	"ESHIN_PESTILENS_RITUAL",
	"ESHIN_SKYRE_RITUAL"
}
local contract_council_countdown_start = 3;
local contract_council_countdown_reset = 10; -- The turns between every council meeting
local contract_per_turn_chance = 5;
local contract_timeout_after_issue = 10; -- The turns each contract is active for
local contract_level_2_unlock = 1;
local contract_level_3_unlock = 20;
local contract_level_weights = {50, 40, 30};
local dust_xp_gain = 1200;

function add_clan_contracts_listeners_skv()
	out("#### Adding Clan Contracts Listeners skv ####");
	
	local contract_council_countdown = cm:get_saved_value("contract_council_countdown_skv") or contract_council_countdown_start;
	common.set_context_value("contract_council_counter", contract_council_countdown);
	
	cm:add_faction_turn_start_listener_by_name(
		"contract_FactionTurnStart_skv",
		contract_faction,
		function(context)
			local faction = context:faction();
			local possible_clans = weighted_list:new();
			local turn_number = cm:model():turn_number();
			local generate_chance = contract_per_turn_chance;
			
			if contract_council_countdown > 1 then
				contract_council_countdown = contract_council_countdown - 1;
			else
				generate_chance = 100;
				contract_council_countdown = contract_council_countdown_reset;
			end
			
			cm:set_saved_value("contract_council_countdown_skv", contract_council_countdown);
			common.set_context_value("contract_council_counter", contract_council_countdown);
			
			for i = 1, #contract_clans do
				local clan = contract_clans[i];
				local reputation = faction:pooled_resource_manager():resource("skv_clan_" .. clan.key);
				
				if not reputation:is_null_interface() then
					local reputation_value = reputation:value();
					
					if clan.level < 2 and reputation_value >= contract_level_2_unlock then
						clan.level = 2;
					end
					
					if clan.level < 3 and reputation_value >= contract_level_3_unlock then
						clan.level = 3;
					end
					
					if turn_number > clan.last_contract then
						if cm:model():random_percent(generate_chance) then
							for j = 1, clan.level do
								for k = 1, #contract_clans do
									if contract_clans[k].key ~= clan.key then
										possible_clans:add_item({clan = clan.key, target = contract_clans[k].key, level = j}, contract_level_weights[j]);
									end
								end
							end
						end
					end
				end
			end
			
			if #possible_clans.items > 0 then
				local contract = possible_clans:weighted_select();
				local ritual_key = "wh2_dlc14_eshin_contracts_" .. contract.clan .. "_" .. contract.target .. "_" .. contract.level;
				
				cm:unlock_ritual(faction, ritual_key, contract_council_countdown_reset);
				cm:trigger_incident(faction:name(), "wh2_dlc14_incident_skv_new_contract_" .. contract.clan, true, true);
				
				for i = 1, #contract_clans do
					if contract.clan == contract_clans[i].key then
						contract_clans[i].last_contract = turn_number + contract_council_countdown_reset;
						break;
					end
				end
			end
		end,
		true
	);
	
	core:add_listener(
		"contract_RitualCompletedEvent_skv",
		"RitualCompletedEvent",
		function(context)
			local ritual_category = context:ritual():ritual_category();
			
			if context:performing_faction():name() == contract_faction then
				for i = 1, #contract_ritual_categories do
					if ritual_category == contract_ritual_categories[i] then
						return true
					end
				end
			end
		end,
		function(context)
			local faction = context:performing_faction();
			
			cm:lock_rituals_in_category(faction, context:ritual():ritual_category());
			
			for i = 1, #contract_clans do
				local clan = contract_clans[i];
				local reputation = faction:pooled_resource_manager():resource("skv_clan_" .. clan.key);
				
				if not reputation:is_null_interface() then
					if reputation:value() > 0 then
						cm:make_diplomacy_available(contract_faction, "wh2_main_skv_clan_" .. clan.key)
					end
				end
			end
		end,
		true
	);
	
	-- Lock all rituals at the start
	if is_new_game_skv() then
		local faction = cm:get_faction(contract_faction);
		
		if faction then
			for i = 1, #contract_ritual_categories do
				cm:lock_rituals_in_category(faction, contract_ritual_categories[i]);
			end
		end
	end
end

-- Debug
function contract_skv(clan1, clan2, level)
	local faction = cm:get_faction(contract_faction)
	
	if faction:is_factions_turn() then
		cm:unlock_ritual(faction, "wh2_dlc14_eshin_contracts_" .. clan1 .. "_" .. clan2 .. "_" .. level, contract_council_countdown_reset);
		cm:trigger_incident(contract_faction, "wh2_dlc14_incident_skv_new_contract_" .. clan1, true, true);
	end
end

local function show_skv_shadowy_dealings_button(state)
	local ui_root = core:get_ui_root()
	out("shy0 show_skv_shadowy_dealings_button print:")
	local ui_sotek =
		find_uicomponent(ui_root, "faction_buttons_docker", "button_group_management", "button_shadowy_dealings")
	out("shy0 show_skv_shadowy_dealings_button print:1")
	if not ui_sotek then
		out("shy0 show_skv_shadowy_dealings_button ERROR: button find failed!")
		return false;
	end
	
	ui_sotek:SetVisible(state)
	
	ui_sotek = find_uicomponent(ui_root,"hud_campaign","resources_bar_holder","resources_bar","warpstone_dust_holder");
	if not ui_sotek then
		out("shy0 warpstone_dust_holder ERROR: button find failed!")
		return false;
	end
	ui_sotek:SetVisible(state)
    ui_sotek = find_uicomponent(ui_root,"hud_campaign","resources_bar_holder","resources_bar","warpstone_dust_holder","warpstone_dust_bar");
	if not ui_sotek then
		out("shy0 warpstone_dust_bar ERROR: button find failed!")
		return false;
	end
	ui_sotek:SetVisible(state)
    
    ui_sotek = find_uicomponent(ui_root,"hud_campaign","resources_bar_holder","resources_bar","warpstone_dust_holder","warpstone_dust_skv_resource_bar");
	if not ui_sotek then
		out("shy0 warpstone_dust_skv_resource_bar ERROR: button find failed!")
		return false;
	end
	ui_sotek:SetVisible(state)  
    ui_sotek = find_uicomponent(ui_root,"hud_campaign","resources_bar_holder","resources_bar","warpstone_dust_holder","warpstone_dust_bar","resource_list");
	if not ui_sotek then
		out("shy0 resource_list ERROR: button find failed!")
		return false;
	end
	ui_sotek:SetVisible(false)
    
    
    out("shy0 show_skv_shadowy_dealings_button print:return true")
	return true;
end

cm:add_first_tick_callback(
    function()

        out("==== snikch new ui Dealing ====");	
		local local_faction = cm:get_local_faction_name(true)
		out("snikch new ui Dealing :local_faction " .. local_faction)
        local is_create_ui = true;
        if false ==  is_create_ui then
            return;
        end 

		local script_belongs_faction = cm:model():world():faction_by_key(local_faction);
        
        if local_faction ~= contract_faction_skv and script_belongs_faction:culture() == "wh2_main_skv_skaven" then
            local xmlfile_name = "ui/campaign ui/warpstone_dust_bar_"..local_faction..".twui.xml";
            out("snikch new ui Dealing :xmlfile_name " .. xmlfile_name);
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar", "warpstone_dust_holder");


            local parent_ui2 = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar", "warpstone_dust_holder");
            local result = core:get_or_create_component("warpstone_dust_skv_resource_bar", xmlfile_name, parent_ui2)
            if not result then
                script_error("snikch Dust: ".. "ERROR: could not create dust bar ui component? How can this be?");
                return false;
            end;
            result:SetVisible(false)
        end
        if script_belongs_faction:culture() == "wh2_main_skv_skaven" and contract_faction ~= "" and local_faction == contract_faction then	
            show_skv_shadowy_dealings_button(true);		
        elseif script_belongs_faction:culture() == "wh2_main_skv_skaven" and contract_faction == "" and local_faction ~= contract_faction_skv then
            show_skv_shadowy_dealings_button(false)
        end
    end
);


function is_new_game_skv()
	return dust_is_new_ganme;
end

function wh2_dlc14_snikch_clan_contracts_skv()
	local local_faction = cm:get_local_faction_name(true)
	out("wh2_dlc14_snikch_clan_contracts_skv:local_faction " .. local_faction)
	local script_belongs_faction = cm:model():world():faction_by_key(local_faction);
	if script_belongs_faction:culture() == "wh2_main_skv_skaven" and contract_faction ~= "" and local_faction == contract_faction then	
		show_skv_shadowy_dealings_button(true);
		add_clan_contracts_listeners_skv();
		wh2_dlc14_snikch_shadowy_dealings_skv_start(contract_faction);
		is_new_game = false;
--        update_mercenary_pool(local_faction)
--		add_ritual_complete_listen_flesh_lab_sky()
--		core:remove_listener("AI_flesh_lab_listener")
	elseif
		script_belongs_faction:culture() == "wh2_main_skv_skaven" and contract_faction == "" and local_faction ~= contract_faction_skv then
		show_skv_shadowy_dealings_button(false)
	end

	core:add_listener(
		"confederation_snikch_skv_faction",
		"FactionJoinsConfederation",
		function(context)
			local faction_name = context:faction():name()
			out("snikch:faction_name" .. faction_name)
			return faction_name == contract_faction_skv
		end,
		function(context)
			local faction = context:confederation()			
			--   local confederation_faction = context:confederation();
			local confederation_name = context:confederation():name()
			out("snikch:confederation_name" .. confederation_name)
			local faction_name_log = context:faction():name()
			out("snikch:faction_name_log" .. faction_name_log)
			if faction:is_human() and contract_faction == "" then
				contract_faction = confederation_name;				
				show_skv_shadowy_dealings_button(true);
				add_clan_contracts_listeners_skv();
				wh2_dlc14_snikch_shadowy_dealings_skv_start(contract_faction);
				dust_is_new_ganme = false;
--               update_mercenary_pool(throt_faction_name)
--				current_growth_vat_value = faction:pooled_resource("skv_growth_vat"):value()
--				add_ritual_complete_listen_flesh_lab_sky();
--				core:remove_listener("AI_flesh_lab_listener")
			else
				out("snikch:fation is not hunman")
			end
		end,
		true
	)
    
	
end


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("contract_faction", contract_faction, context);
		cm:save_named_value("dust_is_new_ganme", dust_is_new_ganme, context);
		cm:save_named_value("contract_clans_skv", contract_clans, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			contract_faction = cm:load_named_value("contract_faction", "", context);
			dust_is_new_ganme = cm:load_named_value("dust_is_new_ganme", true, context);
			contract_clans = cm:load_named_value("contract_clans_skv", contract_clans, context);
		end
	end
);