
local chs_eyes_of_god_table = {};
local default_faction = "wh_main_chs_chaos";
local reinit = false;

function chs_eyes_of_god_table_add(faction_name,confederation_faction_name)
    local faction_list = {[faction_name]={faction_name,confederation_faction_name}};
    local faction_key = faction_name;
   
		         
    for j = 1, #faction_list[faction_key] do
        out("chs_eyes_of_god_table_add "..j.." is "..faction_list[faction_key][j])
    end
        
	
    local faction_index = 0;
    if #chs_eyes_of_god_table == 0 then
        table.insert(chs_eyes_of_god_table,faction_list)
        return;
    end

    if #chs_eyes_of_god_table > 0 then
        for i = 1, #chs_eyes_of_god_table do
            if chs_eyes_of_god_table[i][faction_name] ~= nil then
                faction_index = i;
            end
        end
        if faction_index == 0 then
            table.insert(chs_eyes_of_god_table,faction_list)
        else
            local index = 0
            for i = 1, #chs_eyes_of_god_table[faction_index][faction_name] do
                if chs_eyes_of_god_table[faction_index][faction_name][i] == confederation_faction_name then
                    index = i;
                    break;
                end
            end
            if index == 0 then
                table.insert(chs_eyes_of_god_table[faction_index][faction_name],confederation_faction_name);     
            end           
        end        
    end
   
    for i = 1, #chs_eyes_of_god_table do
		if chs_eyes_of_god_table[i][faction_key] ~= nil then            
            for j = 1, #chs_eyes_of_god_table[i][faction_key] do
               out("chs_eyes_of_god_table_add_new "..j.." is "..chs_eyes_of_god_table[i][faction_key][j])
            end
        end
	end
end

function chs_eyes_of_god_table_get_random_faction(faction_name)
	if #chs_eyes_of_god_table == 0 then
		return nil;
	end
    for i = 1, #chs_eyes_of_god_table do
		if chs_eyes_of_god_table[i][faction_name] ~= nil then            
            for j = 1, #chs_eyes_of_god_table[i][faction_name] do   
                local num = cm:random_number(#chs_eyes_of_god_table[i][faction_name],1)
                out("radom num is "..num)             
                return chs_eyes_of_god_table[i][faction_name][num];
            end
        end
    end
	return nil;
end

function eye_of_the_gods:generate_dilemma_chs(faction_key)
    local faction_name = chs_eyes_of_god_table_get_random_faction(faction_key);
    local dilemma_key = self.factions_to_dilemmas[faction_key] or self.factions_to_dilemmas.default
    if faction_name ~= nil then
        dilemma_key = self.factions_to_dilemmas[faction_name] or self.factions_to_dilemmas.default
    end  
	
	local dilemma_builder = cm:create_dilemma_builder(dilemma_key)
	local choices = dilemma_builder:possible_choices()
	local faction_interface = cm:get_faction(faction_key)

	for i = 1, #choices do
		local payload = self:generate_payload(choices[i], faction_interface, dilemma_key)
		dilemma_builder:add_choice_payload(choices[i], payload)
	end

	cm:launch_custom_dilemma_from_builder(dilemma_builder, cm:get_faction(faction_key))
end

function chs_eyes_of_god_test()
    core:add_listener(
			"chs_eyes_of_god_test",
			"FactionTurnStart",
			function(context)
				local faction = context:faction()
				return faction:can_be_human() and faction:subculture() == "wh_main_sc_chs_chaos"
			end,
			function(context)
				local faction = context:faction()
				local faction_name = faction:name();
				if #chs_eyes_of_god_table > 0 then
                    for i = 1, #chs_eyes_of_god_table do
                        if chs_eyes_of_god_table[i][faction_name] ~= nil then
                             eye_of_the_gods:generate_dilemma_chs(faction_name);
                        end
                    end                        
                end						
			end,
			true
		)
end

function chs_eyes_of_god_reinit()
    out("chs_eyes_of_god_reinit start");
	core:remove_listener("EotGRitualCompletedEvent");
	if reinit == false then
        core:add_listener(
		"EotGRitualCompletedEvent_chs",
		"RitualCompletedEvent",
		function(context)
			return context:performing_faction() ~= nil and context:ritual():ritual_category() == eye_of_the_gods.ritual_category_key
		end,
		function(context)
			eye_of_the_gods:generate_dilemma_chs(context:performing_faction():name())
		end,
		true
        )
        reinit = true;
	end
 --   chs_eyes_of_god_test();
end

cm:add_first_tick_callback(
        function()
           local length = #chs_eyes_of_god_table;
           if length > 0 then
                core:remove_listener("EotGRitualCompletedEvent");
           end	           
        end);

function wh3_main_campaign_all_chs_eyes_of_god()
	out("wh3_main_campaign_all_chs_eyes_of_god start");	
	local length = #chs_eyes_of_god_table;
    if length > 0 then
       chs_eyes_of_god_reinit();
    end	
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("chs_eyes_of_god_table", chs_eyes_of_god_table, context)		
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			chs_eyes_of_god_table = cm:load_named_value("chs_eyes_of_god_table", chs_eyes_of_god_table, context)			
		end
	end
)