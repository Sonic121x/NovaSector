/obj/item/organ/lungs/nitrogen
	name = "氮气肺"
	desc = "一套用于呼吸氮气的肺。"
	safe_oxygen_min = 0	//Dont need oxygen
	safe_oxygen_max = 2 //But it is quite toxic
	safe_nitro_min = 10 // Atleast 10 nitrogen
	oxy_damage_type = TOX
	oxy_breath_dam_min = 6
	oxy_breath_dam_max = 20

/obj/item/organ/lungs/nitrogen/vox
	name = "鸟人肺"
	desc = "里面全是灰尘……哇哦。"
	icon_state = "lungs-c"

	cold_level_1_threshold = 0 // Vox should be able to breathe in cold gas without issues?
	cold_level_2_threshold = 0
	cold_level_3_threshold = 0
	organ_flags = ORGAN_ROBOTIC | ORGAN_SYNTHETIC_FROM_SPECIES
