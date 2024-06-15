local local_faction = "wh3_dlc20_chs_valkia";



function chs_valkia_faction_trait_set_faction(faction,local_faction)	
	chs_eyes_of_god_table_add(faction,local_faction);
	chs_enable_win_streaks_feature(faction,local_faction);
	chs_eyes_of_god_reinit();
end



function wh3_dlc20_chs_valkia_faction_traits()
	out("wh3_dlc20_chs_valkia_faction_traits start");
end

