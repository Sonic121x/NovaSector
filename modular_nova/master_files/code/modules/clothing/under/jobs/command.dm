/obj/item/clothing/under/rank/captain
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/command_digi.dmi'
	//NOTE - TG uses "captain.dmi"; because we have a few non-captain items going in here for ease of access, this will just be "command.dmi"

/obj/item/clothing/under/rank/captain/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/under/command.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/command.dmi'

/*
*	CAPTAIN
*/

/obj/item/clothing/under/rank/captain/nova/kilt
	name = "舰长的苏格兰裙"
	desc = "一条午夜蓝色的苏格兰裙，衬有纳米凯夫拉纤维，并饰有金色和一条格子呢肩带。"
	icon_state = "capkilt"

/obj/item/clothing/under/imperial/captain
	name = "舰长的海军连体服"
	desc = "一套白色的海军制服，饰有代表舰长的金色军衔徽章。有两种方法可以摧毁一个人，杀死他，或者毁掉他的名誉。"
	icon_state = "/obj/item/clothing/under/imperial/captain"
	greyscale_colors = "#FFFFFF#FFFFFF#FFFFFF#373741#FFCE5B#FFCE5B#FFCE5B"
	flags_1 = NONE
	armor_type = /datum/armor/clothing_under/rank_captain

/obj/item/clothing/under/imperialskirt/captain
	name = "舰长的海军裙装"
	desc = "一套白色的海军制服，饰有代表舰长的金色军衔徽章。有两种方法可以摧毁一个人，杀死他，或者毁掉他的名誉。"
	greyscale_colors = "#FFFFFF#FFFFFF#373741#FFCE5B#FFCE5B#FFCE5B"
	icon_state = "/obj/item/clothing/under/imperialskirt/captain"
	flags_1 = NONE
	armor_type = /datum/armor/clothing_under/rank_captain

//Donor item for Gandalf - all donors have access
/obj/item/clothing/under/rank/captain/nova/black
	name = "舰长的黑色西装"
	desc = "一套非常时尚，尽管有些过时的海军舰长制服，适合那些以为自己正在指挥一艘战舰的人。"
	icon_state = "captainblacksuit"
	can_adjust = FALSE

/*
*	BLUESHIELD
*/
//Why is this in command.dm? Simple: Centcom.dmi will already be packed with CC/NTNavy/AD/LL/SOL/FTU - all of them more event-based clothes, while this will appear
//on-station often.

/obj/item/clothing/under/rank/blueshield
	icon = 'modular_nova/master_files/icons/obj/clothing/under/command.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/command.dmi'
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/command_digi.dmi'
	name = "蓝盾的西装"
	desc = "一套经典的保镖西装，配有定制的蓝盾蓝色袖口，其中一个口袋上方饰有纳米传讯徽章。"
	icon_state = "blueshield"
	strip_delay = 50
	armor_type = /datum/armor/clothing_under/rank_blueshield
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	alt_covers_chest = TRUE

/datum/armor/clothing_under/rank_blueshield
	melee = 10
	bullet = 5
	laser = 5
	energy = 10
	bomb = 10
	fire = 50
	acid = 50

/obj/item/clothing/under/rank/blueshield/skirt
	name = "蓝盾的西装裙"
	desc = "一套经典的保镖西装裙，配有定制的蓝盾蓝色袖口，其中一个口袋上方饰有纳米传讯徽章。"
	icon_state = "blueshieldskirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/under/rank/blueshield/turtleneck
	name = "蓝盾的高领衫"
	desc = "一件专为最顶尖保镖设计的战术套头衫，配有大量战术口袋以满足你的战术需求。"
	icon_state = "bs_turtleneck"

/obj/item/clothing/under/rank/blueshield/turtleneck/skirt
	name = "蓝盾的裙领衫"
	desc = "一件专为最顶尖保镖设计的战术套头衫——这款没有战术口袋，而是战术性地缺少腿部防护。"
	icon_state = "bs_skirtleneck"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/under/rank/blueshield/consult
	name = "蓝盾的顾问西装"
	desc = "一套不那么战术的制服，由公司以更高的护理标准维护，裁剪得十分考究，其金色镶边与纳米传讯顾问的制服相配。象征着团结、凝聚力，以及多得烦人的文书工作。"
	icon_state = "bs_consult"

/obj/item/clothing/under/rank/blueshield/consult/skirt
	name = "蓝盾的顾问裙装"
	icon_state = "bs_consult_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/under/rank/blueshield/russian
	name = "蓝盾的运动服"
	desc = "一款旧式连体服，原为士兵军事用途设计，如今依然非常实用，已按照纳米传讯的新标准进行染色和缝制。"
	icon_state = "bs_rus"
	can_adjust = FALSE

/obj/item/clothing/under/rank/blueshield/formal
	name = "蓝盾的正式制服"
	desc = "一套经济高效的制服，让你在人群中脱颖而出，又不会过于引人注目。"
	icon_state = "bs_formal"

/obj/item/clothing/under/imperialvest/blueshield
	name = "蓝盾的海军裙装"
	desc = "授予盾卫同僚的高级制服，代表着中央司令部的庞大海军舰队。"
	icon_state = "/obj/item/clothing/under/imperialvest/bs"
	greyscale_colors = "#363740#363740#3c485a#373741#bbbbbb#21212B#bbbbbb#bbbbbb"
	flags_1 = NONE
	armor_type = /datum/armor/clothing_under/rank_blueshield

/obj/item/clothing/under/imperialskirtvest/blueshield
	name = "蓝盾的海军裙装"
	desc = "授予盾卫同僚的高级制服，代表着中央司令部的庞大海军舰队。"
	greyscale_colors = "#363740#3c485a#373741#bbbbbb#21212B#bbbbbb#bbbbbb"
	icon_state = "/obj/item/clothing/under/imperialskirtvest/bs"
	flags_1 = NONE
	armor_type = /datum/armor/clothing_under/rank_blueshield

/*
*	NT CONSULTANT
*/
//See Blueshield note - tl;dr, this role is a station role, while Centcom.dmi is more event roles

/obj/item/clothing/under/rank/nanotrasen_consultant
	icon = 'modular_nova/master_files/icons/obj/clothing/under/command.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/command.dmi'
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/command_digi.dmi'
	desc = "这是一件绿色的连体服，带有一些金色标记，表示“纳米传讯顾问”的职级。"
	name = "纳米传讯顾问的连体服"
	icon_state = "nt_consultant"
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/rank/nanotrasen_consultant/skirt
	name = "纳米传讯顾问连身裙"
	desc = "这是一件绿色的连身裙，带有一些金色标记，表示“纳米传讯顾问”的职级。"
	icon_state = "nt_consultant_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/under/imperial/nanotrasen_consultant
	name = "纳米传讯顾问海军制服"
	desc = "授予顾问和代表的高级制服，代表着中央司令部的庞大海军舰队。"
	icon_state = "/obj/item/clothing/under/imperial/nanotrasen_consultant"
	greyscale_colors = "#54a57e#54a57e#47464e#373741#ffce5b#ffce5b#f2b050"
	flags_1 = NONE

/obj/item/clothing/under/imperialskirt/nanotrasen_consultant
	name = "纳米传讯顾问海军裙装"
	desc = "授予顾问和代表的高级制服，代表着中央司令部的庞大海军舰队。"
	greyscale_colors = "#54a57e#47464e#373741#ffce5b#ffce5b#f2b050"
	icon_state = "/obj/item/clothing/under/imperialskirt/nanotrasen_consultant"
	flags_1 = NONE

/*
*	Bridge Officer
*/

/obj/item/clothing/under/rank/bridge_officer
	name = "舰桥军官连体服"
	desc = "这是一件蓝色的连体服，带有银色标记，表示“舰桥军官”的职级。"
	icon_state = "bo_uniform"
	icon = 'modular_nova/master_files/icons/obj/clothing/under/command.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/command.dmi'
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/command_digi.dmi'
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/obj/item/clothing/under/rank/bridge_officer/skirt
	name = "舰桥军官连身裙"
	desc = "这是一件蓝色的连身裙，带有银色标记，表示“舰桥军官”的职级。"
	icon_state = "bo_skirt"
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/under/rank/bridge_officer/turtle
	name = "舰桥军官高领衫"
	desc = "这是一件蓝色的高领衫，带有银色标记，表示“舰桥军官”的职级。"
	icon_state = "bo_turtleneck"

/obj/item/clothing/under/rank/bridge_officer/turtle/skirt
	name = "舰桥军官裙领衫"
	desc = "这是一件蓝色的裙领衫，带有银色标记，表示“舰桥军官”的职级。"
	icon_state = "bo_skirtleneck"
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/under/imperial/bridge_officer
	name = "舰桥军官海军制服"
	desc = "授予舰桥勤务人员的“高级”制服。你确实通过了实习期，对吧？"
	icon_state = "/obj/item/clothing/under/imperial/bridge_officer"
	greyscale_colors = "#41579a#41579a#3b3c3f#373741#ccced1#41579a#ccced1"
	flags_1 = NONE

/obj/item/clothing/under/imperialskirt/bridge_officer
	name = "舰桥军官海军裙装"
	desc = "授予舰桥勤务人员的“高级”制服。你确实通过了实习期，对吧？"
	greyscale_colors = "#41579a#3b3c3f#373741#ccced1#41579a#ccced1"
	icon_state = "/obj/item/clothing/under/imperialskirt/bridge_officer"
	flags_1 = NONE

/*
*	UNASSIGNED (Any head of staff)
*/

/obj/item/clothing/under/rank/captain/nova/utility
	name = "指挥勤务制服"
	desc = "空间站指挥人员穿着的勤务制服。"
	icon_state = "util_com"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_BIG_LEGS_MASK
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/captain/nova/utility/syndicate
	armor_type = /datum/armor/clothing_under/utility_syndicate
	has_sensor = NO_SENSORS

/obj/item/clothing/under/imperial
	desc = "一套海军制服，配有表示军官的军衔徽章。无法抵御爆能枪火力。"
	name = "军官海军连体服"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_BIG_LEGS_MASK
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	greyscale_colors = "#A49C9C#A49C9C#A49C9C#373741#FFFFFF#FFFFFF#FFFFFF"
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/imperial"
	post_init_icon_state = "officersnaval"
	greyscale_config = /datum/greyscale_config/officersnaval
	greyscale_config_worn = /datum/greyscale_config/officersnaval/worn
	greyscale_config_worn_digi = /datum/greyscale_config/officersnaval/worn/digi
	flags_1 = IS_PLAYER_COLORABLE_1
	can_adjust = FALSE

/obj/item/clothing/under/imperialskirt
	desc = "一条海军裙，配有表示军官的军衔徽章。无法抵御爆能枪火力。"
	name = "军官海军连体裙"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	greyscale_colors = "#A49C9C#A49C9C#373741#FFFFFF#FFFFFF#FFFFFF"
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/imperialskirt"
	post_init_icon_state = "officersnavalskirt"
	greyscale_config = /datum/greyscale_config/officersnavalskirt
	greyscale_config_worn = /datum/greyscale_config/officersnavalskirt/worn
	flags_1 = IS_PLAYER_COLORABLE_1
	can_adjust = FALSE

/obj/item/clothing/under/imperialvest
	post_init_icon_state = "officersnavalvest"
	greyscale_colors = "#39393f#39393f#39393f#373741#FFFFFF#21212B#f8d860#a52f29"
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	greyscale_config = /datum/greyscale_config/officersnavalvest
	greyscale_config_worn = /datum/greyscale_config/officersnavalvest/worn
	greyscale_config_worn_digi = /datum/greyscale_config/officersnavalvest/worn/digi
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_BIG_LEGS_MASK
	armor_type = /datum/armor/clothing_under/security_head_of_security
	can_adjust = FALSE

/obj/item/clothing/under/imperialskirtvest
	post_init_icon_state = "officersnavalskirtvest"
	greyscale_colors = "#39393f#39393f#373741#FFFFFF#21212B#f8d860#a52f29"
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	greyscale_config = /datum/greyscale_config/officersnavalskirtvest
	greyscale_config_worn = /datum/greyscale_config/officersnavalskirtvest/worn
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	armor_type = /datum/armor/clothing_under/security_head_of_security
	can_adjust = FALSE

/obj/item/clothing/under/imperial/red
	name = "红色海军连体服"
	desc = "一套普通的红色海军连体服，胸前别着军衔徽章。"
	icon_state = "/obj/item/clothing/under/imperial/red"
	greyscale_colors = "#C12E24#C12E24#C12E24#373741#FFFFFF#2979CD#2979CD"
	flags_1 = NONE

/*
*	MISC
*/

/obj/item/clothing/under/rank/captain/nova/pilot
	name = "穿梭机飞行员连体服"
	desc = "这是一套蓝色连体服，带有银色标记，表明穿着者是认证飞行员。"
	icon_state = "pilot"
	can_adjust = FALSE

/obj/item/clothing/under/rank/captain/nova/pilot/skirt
	name = "穿梭机飞行员连体裙"
	desc = "这是一条蓝色连体裙，带有银色标记，表明穿着者是认证飞行员。"
	icon_state = "pilot_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	gets_cropped_on_taurs = FALSE
