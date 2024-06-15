local local_faction = "wh3_dlc20_chs_azazel";



function chs_azazel_faction_trait_set_faction(faction,local_faction)	
	chs_seduce_units(faction,local_faction);
	chs_eyes_of_god_table_add(faction,local_faction);
	chs_eyes_of_god_reinit();
end



function wh3_dlc20_chs_azazel_faction_traits()
	out("wh3_dlc20_chs_azazel_faction_traits start");
end

