// Slightly improved version of the normal RCD, mostly as an engineering 'I got hella bread' purchase
/obj/item/construction/rcd/improved
	name = "改进型快速建造装置"
	desc = "一种用于快速建造与解构的设备。相比标准型号升级了材料存储容量，但牺牲了建造速度。可使用铁、塑钢、玻璃或压缩物质弹匣进行装填。"
	icon_state = "ircd"
	inhand_icon_state = "ircd"
	max_matter = 220
	matter = 220
	delay_mod = 1.3
	construction_upgrades = RCD_UPGRADE_FRAMES | RCD_UPGRADE_SIMPLE_CIRCUITS

// Unimproved repainted RCD that Interdyne's cargo/atrium gets
/obj/item/construction/rcd/loaded/interdyne
	desc = "一种用于快速建造与解构的设备。可使用铁、塑钢、玻璃或压缩物质弹匣进行装填。这台看起来被重新喷涂成了黑红色，但仍保留标准功能。";
	icon_state = "ircd"
	inhand_icon_state = "ircd"
