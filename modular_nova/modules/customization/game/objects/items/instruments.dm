// MODULAR INSTRUMENTS

/obj/item/instrument/musicalduffy
	name = "可疑的音乐飞蛾"
	desc = "一只看起来很眼熟的飞蛾，戴着一副时髦的眼镜和一台钢琴，能和谐地演奏出飞蛾的尖叫痛苦。"
	icon = 'modular_nova/master_files/icons/obj/instruments.dmi'
	icon_state = "musical_duffy"
	allowed_instrument_ids = "mothscream"
	attack_verb_continuous = list("flutters", "flaps", "squeaks")
	attack_verb_simple = list("flutter", "flap", "squeak")
	w_class = WEIGHT_CLASS_TINY
	force = 0
	hitsound = 'sound/mobs/humanoids/moth/moth_chitter.ogg'
