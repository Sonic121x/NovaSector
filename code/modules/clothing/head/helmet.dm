/obj/item/clothing/head/helmet
	name = "头盔"
	desc = "标准安保装备，能够保护头部免受冲击。"
	icon = 'icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'icons/mob/clothing/head/helmet.dmi'
	icon_state = "helmet"
	base_icon_state = "helmet"
	inhand_icon_state = "helmet"
	armor_type = /datum/armor/head_helmet
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_TEMP_PROTECT
	strip_delay = 6 SECONDS
	clothing_flags = SNUG_FIT | STACKABLE_HELMET_EXEMPT
	flags_cover = HEADCOVERSEYES|EARS_COVERED
	flags_inv = HIDEHAIR
	dog_fashion = /datum/dog_fashion/head/helmet

/datum/armor/head_helmet
	melee = 35
	bullet = 30
	laser = 30
	energy = 40
	bomb = 25
	fire = 50
	acid = 50
	wound = 10

/obj/item/clothing/head/helmet/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/clothing/head/helmet/sec
	var/flipped_visor = FALSE
	sound_vary = TRUE
	equip_sound = 'sound/items/handling/helmet/helmet_equip1.ogg'
	pickup_sound = 'sound/items/handling/helmet/helmet_pickup1.ogg'
	drop_sound = 'sound/items/handling/helmet/helmet_drop1.ogg'
	visor_toggle_up_sound = SFX_VISOR_UP
	visor_toggle_down_sound = SFX_VISOR_DOWN
	hair_mask = /datum/hair_mask/standard_hat_low

/obj/item/clothing/head/helmet/sec/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seclite_attachable, light_icon_state = "flight")

/obj/item/clothing/head/helmet/sec/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(issignaler(attacking_item))
		var/obj/item/assembly/signaler/attached_signaler = attacking_item
		// There's a flashlight in us. Remove it first, or it'll be lost forever!
		var/obj/item/flashlight/seclite/blocking_us = locate() in src
		if(blocking_us)
			to_chat(user, span_warning("[blocking_us] 挡着呢，先把它拿掉！"))
			return TRUE

		if(!attached_signaler.secured)
			to_chat(user, span_warning("先固定好[attached_signaler]！"))
			return TRUE

		to_chat(user, span_notice("你将[attached_signaler]安装到[src]上。"))

		qdel(attached_signaler)
		var/obj/item/bot_assembly/secbot/secbot_frame = new(drop_location())
		var/held_index = user.is_holding(src)
		qdel(src)
		if (held_index)
			user.put_in_hand(secbot_frame, held_index)
		return TRUE

	return ..()

/obj/item/clothing/head/helmet/sec/attack_self(mob/user)
	. = ..()
	if(.)
		return
	balloon_alert(user, "[flags_inv & HIDEHAIR ? "loosening" : "tightening"]束带...")
	if(!do_after(user, 3 SECONDS, src))
		return
	flags_inv ^= HIDEHAIR
	balloon_alert(user, "[flags_inv & HIDEHAIR ? "tightened" : "loosened"] 束带")
	return TRUE

/obj/item/clothing/head/helmet/sec/click_alt(mob/user)
	flipped_visor = !flipped_visor
	balloon_alert(user, "面罩已翻转")
	// base_icon_state is modified for seclight attachment component
	base_icon_state = "[initial(base_icon_state)][flipped_visor ? "-novisor" : ""]"
	icon_state = base_icon_state
	if (flipped_visor)
		flags_cover &= ~HEADCOVERSEYES
		playsound(src, SFX_VISOR_DOWN, 20, TRUE, -1)
	else
		flags_cover |= HEADCOVERSEYES
		playsound(src, SFX_VISOR_UP, 20, TRUE, -1)
	update_appearance()
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/head/helmet/press
	name = "记者头盔"
	desc = "一顶用于区分<i>非战斗人员</i>“记者”成员的蓝色头盔，好像谁在乎似的。"
	icon_state = "helmet_press"
	base_icon_state = "helmet_press"
	sound_vary = TRUE
	equip_sound = 'sound/items/handling/helmet/helmet_equip1.ogg'
	pickup_sound = 'sound/items/handling/helmet/helmet_pickup1.ogg'
	drop_sound = 'sound/items/handling/helmet/helmet_drop1.ogg'

/obj/item/clothing/head/helmet/press/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seclite_attachable, light_icon_state = "flight")

/obj/item/clothing/head/helmet/press/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += emissive_appearance(icon_file, "[icon_state]-emissive", src, alpha = src.alpha, effect_type = EMISSIVE_SPECULAR)

/obj/item/clothing/head/helmet/alt
	name = "防弹头盔"
	desc = "一种防弹战斗头盔，能在一定程度上保护佩戴者免受传统投射武器和炸药的伤害。"
	icon_state = "helmetalt"
	base_icon_state = "helmetalt"
	inhand_icon_state = "helmet"
	armor_type = /datum/armor/helmet_alt
	dog_fashion = null
	sound_vary = TRUE
	equip_sound = 'sound/items/handling/helmet/helmet_equip1.ogg'
	pickup_sound = 'sound/items/handling/helmet/helmet_pickup1.ogg'
	drop_sound = 'sound/items/handling/helmet/helmet_drop1.ogg'

/datum/armor/helmet_alt
	melee = 15
	bullet = 60
	laser = 10
	energy = 10
	bomb = 40
	fire = 50
	acid = 50
	wound = 5

/obj/item/clothing/head/helmet/alt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seclite_attachable, light_icon_state = "flight")

/obj/item/clothing/head/helmet/marine
	name = "战术头盔"
	desc = "一顶黑色的战术头盔，用一块玻璃板将外界的危险隔绝，仅此而已。"
	icon_state = "marine_command"
	base_icon_state = "marine_command"
	inhand_icon_state = "marine_helmet"
	armor_type = /datum/armor/helmet_marine
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	clothing_flags = STOPSPRESSUREDAMAGE | STACKABLE_HELMET_EXEMPT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	dog_fashion = null
	sound_vary = TRUE
	equip_sound = 'sound/items/handling/helmet/helmet_equip1.ogg'
	pickup_sound = 'sound/items/handling/helmet/helmet_pickup1.ogg'
	drop_sound = 'sound/items/handling/helmet/helmet_drop1.ogg'

/datum/armor/helmet_marine
	melee = 50
	bullet = 50
	laser = 30
	energy = 25
	bomb = 50
	bio = 100
	fire = 40
	acid = 50
	wound = 20

/obj/item/clothing/head/helmet/marine/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seclite_attachable, starting_light = new /obj/item/flashlight/seclite(src), light_icon_state = "flight")

/obj/item/clothing/head/helmet/marine/security
	name = "海军陆战队重型头盔"
	icon_state = "marine_security"
	base_icon_state = "marine_security"

/obj/item/clothing/head/helmet/marine/engineer
	name = "海军陆战队工程头盔"
	icon_state = "marine_engineer"
	base_icon_state = "marine_engineer"

/obj/item/clothing/head/helmet/marine/medic
	name = "海军陆战队医务兵头盔"
	icon_state = "marine_medic"
	base_icon_state = "marine_medic"

/obj/item/clothing/head/helmet/marine/pmc
	icon_state = "marine"
	desc = "一顶战术黑色头盔，旨在保护头部免受行动中各种伤害。其卓越的生存能力弥补了其不适合太空环境的不足。"
	min_cold_protection_temperature = HELMET_MIN_TEMP_PROTECT
	max_heat_protection_temperature = HELMET_MAX_TEMP_PROTECT
	clothing_flags = null
	armor_type = /datum/armor/pmc

/obj/item/clothing/head/helmet/old
	name = "破损的头盔"
	desc = "标准的安全头盔。由于老化，头盔的遮阳板使得使用者难以看清远处的物体。"
	tint = 2
	sound_vary = TRUE
	equip_sound = 'sound/items/handling/helmet/helmet_equip1.ogg'
	pickup_sound = 'sound/items/handling/helmet/helmet_pickup1.ogg'
	drop_sound = 'sound/items/handling/helmet/helmet_drop1.ogg'

/obj/item/clothing/head/helmet/blueshirt
	name = "蓝色头盔"
	desc = "一顶可靠的蓝色头盔，它总在提醒你：<i>还</i>欠那位工程师一杯啤酒呢。"
	icon_state = "blueshift"
	inhand_icon_state = "blueshift_helmet"
	custom_premium_price = PAYCHECK_COMMAND
	sound_vary = TRUE
	equip_sound = 'sound/items/handling/helmet/helmet_equip1.ogg'
	pickup_sound = 'sound/items/handling/helmet/helmet_pickup1.ogg'
	drop_sound = 'sound/items/handling/helmet/helmet_drop1.ogg'


/obj/item/clothing/head/helmet/toggleable
	visor_vars_to_toggle = NONE
	dog_fashion = null

/obj/item/clothing/head/helmet/toggleable/attack_self(mob/user)
	adjust_visor(user)

/obj/item/clothing/head/helmet/toggleable/update_icon_state()
	. = ..()
	base_icon_state = "[initial(base_icon_state)]"
	var/datum/component/seclite_attachable/light = GetComponent(/datum/component/seclite_attachable)
	if(up)
		base_icon_state += "up"
	light?.on_update_icon_state(src)
	if(!light)
		icon_state = base_icon_state

/obj/item/clothing/head/helmet/toggleable/riot
	name = "防暴头盔"
	desc = "这顶头盔是专门为抵御近距离攻击而设计的。"
	icon_state = "riot"
	base_icon_state = "riot"
	inhand_icon_state = "riot_helmet"
	toggle_message = "You pull the visor down."
	alt_toggle_message = "You push the visor up."
	armor_type = /datum/armor/toggleable_riot
	flags_inv = HIDEHAIR|HIDEEARS|HIDEFACE|HIDESNOUT
	strip_delay = 8 SECONDS
	actions_types = list(/datum/action/item_action/toggle)
	visor_flags_inv = HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	clothing_traits = list(TRAIT_HEAD_INJURY_BLOCKED)
	sound_vary = TRUE
	equip_sound = 'sound/items/handling/helmet/helmet_equip1.ogg'
	pickup_sound = 'sound/items/handling/helmet/helmet_pickup1.ogg'
	drop_sound = 'sound/items/handling/helmet/helmet_drop1.ogg'
	visor_toggle_up_sound = SFX_VISOR_UP
	visor_toggle_down_sound = SFX_VISOR_DOWN

/obj/item/clothing/head/helmet/toggleable/riot/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seclite_attachable, light_icon_state = "flight")

/obj/item/clothing/head/helmet/toggleable/riot/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, 2)

/datum/armor/toggleable_riot
	melee = 50
	bullet = 10
	laser = 10
	energy = 10
	fire = 80
	acid = 80
	wound = 15

/obj/item/clothing/head/helmet/balloon
	name = "气球头盔"
	desc = "一顶用气球制成的头盔。此类头盔在小丑-默剧演员大战中发挥了巨大作用。出人意料地防火。默剧演员们当时做了些难以言表的事情。"
	icon_state = "helmet_balloon"
	inhand_icon_state = "helmet_balloon"
	armor_type = /datum/armor/balloon
	flags_inv = HIDEHAIR|HIDEEARS|HIDESNOUT
	resistance_flags = FIRE_PROOF
	dog_fashion = null

/datum/armor/balloon
	melee = 10
	fire = 60
	acid = 50

/obj/item/clothing/head/helmet/toggleable/justice
	name = "正义之盔"
	desc = "WEEEEOOO. WEEEEEOOO. WEEEEOOOO."
	icon_state = "justice"
	base_icon_state = "justice"
	inhand_icon_state = "justice_helmet"
	toggle_message = "You turn off the lights."
	alt_toggle_message = "You turn on the lights."
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	///Cooldown for toggling the visor.
	COOLDOWN_DECLARE(visor_toggle_cooldown)
	///Looping sound datum for the siren helmet
	var/datum/looping_sound/siren/weewooloop
	sound_vary = TRUE
	equip_sound = 'sound/items/handling/helmet/helmet_equip1.ogg'
	pickup_sound = 'sound/items/handling/helmet/helmet_pickup1.ogg'
	drop_sound = 'sound/items/handling/helmet/helmet_drop1.ogg'
	visor_toggle_up_sound = SFX_VISOR_UP
	visor_toggle_down_sound = SFX_VISOR_DOWN

/obj/item/clothing/head/helmet/toggleable/justice/adjust_visor(mob/living/user)
	if(!COOLDOWN_FINISHED(src, visor_toggle_cooldown))
		return FALSE
	COOLDOWN_START(src, visor_toggle_cooldown, 2 SECONDS)
	return ..()

/obj/item/clothing/head/helmet/toggleable/justice/visor_toggling()
	. = ..()
	if(up)
		weewooloop.start()
	else
		weewooloop.stop()

/obj/item/clothing/head/helmet/toggleable/justice/Initialize(mapload)
	. = ..()
	weewooloop = new(src, FALSE, FALSE)

/obj/item/clothing/head/helmet/toggleable/justice/Destroy()
	QDEL_NULL(weewooloop)
	return ..()

/obj/item/clothing/head/helmet/toggleable/justice/escape
	name = "警报头盔"
	desc = "WEEEEOOO。WEEEEEOOO。拦住那只猴子。WEEEEEOOO。"
	icon_state = "justice2"
	base_icon_state = "justice2"

/obj/item/clothing/head/helmet/swat
	name = "\improper 特警头盔"
	desc = "一个非常强健，不惧太空的头盔，有邪恶的红黑条纹图案。"
	icon_state = "swatsyndie"
	inhand_icon_state = "swatsyndie_helmet"
	armor_type = /datum/armor/helmet_swat
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	clothing_flags = STOPSPRESSUREDAMAGE | STACKABLE_HELMET_EXEMPT
	strip_delay = 8 SECONDS
	resistance_flags = FIRE_PROOF | ACID_PROOF
	dog_fashion = null
	clothing_traits = list(TRAIT_HEAD_INJURY_BLOCKED)
	sound_vary = TRUE
	equip_sound = 'sound/items/handling/helmet/helmet_equip1.ogg'
	pickup_sound = 'sound/items/handling/helmet/helmet_pickup1.ogg'
	drop_sound = 'sound/items/handling/helmet/helmet_drop1.ogg'

/obj/item/clothing/head/helmet/swat/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, 3)

/datum/armor/helmet_swat
	melee = 40
	bullet = 30
	laser = 30
	energy = 40
	bomb = 50
	bio = 90
	fire = 100
	acid = 100
	wound = 15

/obj/item/clothing/head/helmet/swat/nanotrasen
	name = "\improper 特警头盔"
	desc = "一个非常强健的头盔，上面印有纳米传讯的标志。"
	icon_state = "swat"
	base_icon_state = "swat"
	inhand_icon_state = "swat_helmet"
	clothing_flags = STACKABLE_HELMET_EXEMPT
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF

/obj/item/clothing/head/helmet/swat/nanotrasen/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seclite_attachable, light_icon_state = "flight")

/obj/item/clothing/head/helmet/thunderdome
	name = "\improper 竞技场头盔"
	desc = "<i>'让战斗开始吧！'</i>"
	flags_inv = HIDEEARS|HIDEHAIR
	icon_state = "thunderdome"
	inhand_icon_state = "thunderdome_helmet"
	armor_type = /datum/armor/helmet_thunderdome
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	strip_delay = 8 SECONDS
	dog_fashion = null

/datum/armor/helmet_thunderdome
	melee = 80
	bullet = 80
	laser = 50
	energy = 50
	bomb = 100
	bio = 100
	fire = 90
	acid = 90

/obj/item/clothing/head/helmet/thunderdome/holosuit
	cold_protection = null
	heat_protection = null
	armor_type = /datum/armor/thunderdome_holosuit

/datum/armor/thunderdome_holosuit
	melee = 10
	bullet = 10

/obj/item/clothing/head/helmet/roman
	name = "\improper 罗马头盔"
	desc = "用青铜和皮革制作而成的古代头盔。"
	flags_inv = HIDEEARS|HIDEHAIR
	flags_cover = HEADCOVERSEYES
	armor_type = /datum/armor/helmet_roman
	resistance_flags = FIRE_PROOF
	icon_state = "roman"
	inhand_icon_state = "roman_helmet"
	strip_delay = 10 SECONDS
	dog_fashion = null

/datum/armor/helmet_roman
	melee = 25
	laser = 25
	energy = 10
	bomb = 10
	fire = 100
	acid = 50
	wound = 5

/obj/item/clothing/head/helmet/roman/fake
	desc = "用塑料和皮革制作而成的古代头盔。"
	armor_type = /datum/armor/none

/obj/item/clothing/head/helmet/roman/legionnaire
	name = "\improper 罗马军团头盔"
	desc = "用青铜和皮革制作而成的古代头盔。头盔顶部配有一个红色羽毛帽饰。"
	icon_state = "roman_c"

/obj/item/clothing/head/helmet/roman/legionnaire/fake
	desc = "用塑料和皮革制作而成的古代头盔。头盔顶部配有一个红色羽毛帽饰。"
	armor_type = /datum/armor/none

/obj/item/clothing/head/helmet/gladiator
	name = "角斗士头盔"
	desc = "Ave, Imperator, morituri te salutant."
	icon_state = "gladiator"
	inhand_icon_state = "gladiator_helmet"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	flags_cover = HEADCOVERSEYES
	dog_fashion = null

/obj/item/clothing/head/helmet/taghelm
	flags_cover = HEADCOVERSEYES
	// Offer about the same protection as a hardhat.
	armor_type = /datum/armor/helmet_taghelm
	dog_fashion = null
	sound_vary = TRUE
	equip_sound = 'sound/items/handling/helmet/helmet_equip1.ogg'
	pickup_sound = 'sound/items/handling/helmet/helmet_pickup1.ogg'
	drop_sound = 'sound/items/handling/helmet/helmet_drop1.ogg'

/datum/armor/helmet_taghelm
	melee = 15
	bullet = 10
	laser = 20
	energy = 10
	bomb = 20
	acid = 50

/obj/item/clothing/head/helmet/taghelm/red
	name = "红色镭射标记头盔"
	desc = "他们选择了自己的结局。"
	icon_state = "redtaghelm"
	inhand_icon_state = "redtag_helmet"

/obj/item/clothing/head/helmet/taghelm/blue
	name = "蓝色镭射标记头盔"
	desc = "他们需要更多人。"
	icon_state = "bluetaghelm"
	inhand_icon_state = "bluetag_helmet"

/obj/item/clothing/head/helmet/knight
	name = "中世纪头盔"
	desc = "一顶经典的金属头盔。"
	icon_state = "knight_green"
	inhand_icon_state = "knight_helmet"
	armor_type = /datum/armor/helmet_knight
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	resistance_flags = NONE
	strip_delay = 8 SECONDS
	dog_fashion = null
	clothing_traits = list(TRAIT_HEAD_INJURY_BLOCKED)

/obj/item/clothing/head/helmet/knight/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, 3)

/datum/armor/helmet_knight
	melee = 50
	bullet = 10
	laser = 10
	energy = 10
	fire = 80
	acid = 80

/obj/item/clothing/head/helmet/knight/blue
	icon_state = "knight_blue"

/obj/item/clothing/head/helmet/knight/yellow
	icon_state = "knight_yellow"

/obj/item/clothing/head/helmet/knight/red
	icon_state = "knight_red"

/obj/item/clothing/head/helmet/knight/greyscale
	name = "骑士头盔"
	desc = "一顶经典的金属头盔。如果你把它倒过来，就会发现，它实际上就是个桶。"
	icon_state = "knight_greyscale"
	inhand_icon_state = null
	armor_type = /datum/armor/knight_greyscale
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS //Can change color and add prefix

/obj/item/clothing/head/helmet/durathread
	name = "杜拉棉头盔"
	desc = "用杜拉棉和皮革制作而成的头盔。"
	icon_state = "durathread"
	inhand_icon_state = "durathread_helmet"
	resistance_flags = FLAMMABLE
	armor_type = /datum/armor/helmet_durathread
	strip_delay = 6 SECONDS

/datum/armor/helmet_durathread
	melee = 20
	bullet = 10
	laser = 30
	energy = 40
	bomb = 15
	fire = 40
	acid = 50
	wound = 5

/obj/item/clothing/head/helmet/rus_helmet
	name = "俄式头盔"
	desc = "这顶头盔可以装下一瓶伏特加。"
	icon_state = "rus_helmet"
	inhand_icon_state = "rus_helmet"
	armor_type = /datum/armor/helmet_rus_helmet
	sound_vary = TRUE
	equip_sound = 'sound/items/handling/helmet/helmet_equip1.ogg'
	pickup_sound = 'sound/items/handling/helmet/helmet_pickup1.ogg'
	drop_sound = 'sound/items/handling/helmet/helmet_drop1.ogg'

/datum/armor/helmet_rus_helmet
	melee = 25
	bullet = 30
	energy = 10
	bomb = 10
	fire = 20
	acid = 50
	wound = 5

/obj/item/clothing/head/helmet/rus_helmet/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/helmet)

/obj/item/clothing/head/helmet/rus_ushanka
	name = "战斗苏联帽"
	desc = "100% 熊皮。"
	icon_state = "rus_ushanka"
	inhand_icon_state = "rus_ushanka"
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	armor_type = /datum/armor/helmet_rus_ushanka

/datum/armor/helmet_rus_ushanka
	melee = 25
	bullet = 20
	laser = 20
	energy = 30
	bomb = 20
	bio = 50
	fire = -10
	acid = 50
	wound = 5

/obj/item/clothing/head/helmet/elder_atmosian
	name = "\improper 资深大气技术员头盔"
	desc = "一顶由人类可获取的最坚固、最稀有材料制成的卓越头盔。"
	icon_state = "h2helmet"
	inhand_icon_state = "h2_helmet"
	armor_type = /datum/armor/helmet_elder_atmosian
	material_flags = MATERIAL_EFFECTS
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

/datum/armor/helmet_elder_atmosian
	melee = 25
	bullet = 20
	laser = 30
	energy = 30
	bomb = 85
	bio = 10
	fire = 65
	acid = 40
	wound = 15

/obj/item/clothing/head/helmet/military
	name = "粗制头盔"
	desc = "一个廉价制作的壶盔，带有额外的面甲以保护眼睛和嘴巴。"
	icon_state = "military"
	inhand_icon_state = "knight_helmet"
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	flash_protect = FLASH_PROTECTION_FLASH
	strip_delay = 8 SECONDS
	dog_fashion = null
	armor_type = /datum/armor/helmet_military
	sound_vary = TRUE
	equip_sound = 'sound/items/handling/helmet/helmet_equip1.ogg'
	pickup_sound = 'sound/items/handling/helmet/helmet_pickup1.ogg'
	drop_sound = 'sound/items/handling/helmet/helmet_drop1.ogg'

/datum/armor/helmet_military
	melee = 45
	bullet = 25
	laser = 25
	energy = 25
	bomb = 25
	fire = 10
	acid = 50
	wound = 20

/obj/item/clothing/head/helmet/knight/warlord
	name = "金色巴尔布特头盔"
	desc = "头盔之后并非凡人，唯有可怖之念。"
	icon_state = "warlord"
	inhand_icon_state = null
	armor_type = /datum/armor/helmet_warlord
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	flash_protect = FLASH_PROTECTION_FLASH
	slowdown = 0.2

/datum/armor/helmet_warlord
	melee = 70
	bullet = 60
	laser = 70
	energy = 70
	bomb = 40
	fire = 50
	acid = 50
	wound = 30

/obj/item/clothing/head/helmet/durability/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	take_damage(1, BRUTE, 0, 0)

/obj/item/clothing/head/helmet/durability/watermelon
	name = "西瓜头盔"
	desc = "用西瓜挖空制成的头盔。或许能承受几下打击，但别指望它能抵挡太多。"
	icon_state = "watermelon"
	inhand_icon_state = "watermelon"
	flags_inv = HIDEEARS
	dog_fashion = /datum/dog_fashion/head/watermelon
	armor_type = /datum/armor/helmet_watermelon
	max_integrity = 15

/obj/item/clothing/head/helmet/durability/watermelon/fire_resist
	resistance_flags = FIRE_PROOF
	armor_type = /datum/armor/helmet_watermelon_fr

/datum/armor/helmet_watermelon
	melee = 15
	bullet = 10
	energy = 10
	bomb = 10
	fire = 0
	acid = 25
	wound = 5

/datum/armor/helmet_watermelon_fr
	melee = 15
	bullet = 10
	energy = 10
	bomb = 10
	fire = 15
	acid = 30
	wound = 5

/obj/item/clothing/head/helmet/durability/holymelon
	name = "圣瓜头盔"
	desc = "用挖空的圣瓜制成的头盔。或许能承受几下打击，但别指望它能抵挡太多。"
	icon_state = "holymelon"
	inhand_icon_state = "holymelon"
	flags_inv = HIDEEARS
	dog_fashion = /datum/dog_fashion/head/holymelon
	armor_type = /datum/armor/helmet_watermelon
	max_integrity = 15

/obj/item/clothing/head/helmet/durability/holymelon/fire_resist
	resistance_flags = FIRE_PROOF
	armor_type = /datum/armor/helmet_watermelon_fr

/obj/item/clothing/head/helmet/durability/holymelon/Initialize(mapload)
	. = ..()

	AddComponent(
		/datum/component/anti_magic, \
		antimagic_flags = MAGIC_RESISTANCE|MAGIC_RESISTANCE_HOLY, \
		inventory_flags = ITEM_SLOT_OCLOTHING, \
		charges = 1, \
		block_magic = CALLBACK(src, PROC_REF(drain_antimagic)), \
		expiration = CALLBACK(src, PROC_REF(decay)) \
	)

/obj/item/clothing/head/helmet/durability/holymelon/proc/drain_antimagic(mob/user)
	to_chat(user, span_warning("[src] 失去了一些光泽和光彩……"))

/obj/item/clothing/head/helmet/durability/holymelon/proc/decay()
	take_damage(8, BRUTE, 0, 0)

/obj/item/clothing/head/helmet/durability/barrelmelon
	name = "桶瓜头盔"
	desc = "用挖空的桶瓜制成的头盔。和真正的木头一样坚固，但其刚性结构使其更容易破裂。"
	icon_state = "barrelmelon"
	inhand_icon_state = "barrelmelon"
	flags_inv = HIDEEARS
	dog_fashion = /datum/dog_fashion/head/barrelmelon
	armor_type = /datum/armor/helmet_barrelmelon
	max_integrity = 10

/obj/item/clothing/head/helmet/durability/barrelmelon/fire_resist
	resistance_flags = FIRE_PROOF
	armor_type = /datum/armor/helmet_barrelmelon_fr

/datum/armor/helmet_barrelmelon
	melee = 25
	bullet = 20
	energy = 15
	bomb = 10
	fire = 0
	acid = 35
	wound = 10

/datum/armor/helmet_barrelmelon_fr
	melee = 25
	bullet = 20
	energy = 15
	bomb = 10
	fire = 20
	acid = 40
	wound = 10

/obj/item/clothing/head/helmet/dragoon
	name = "龙骑兵头盔"
	desc = "一顶锁子甲头盔，骨架附着龙鳞，并由覆有灰烬的秘银板甲加固。"
	icon_state = "dragoonhelm"
	base_icon_state = "dragoonhelm"
	inhand_icon_state = "dragoonhelm"
	clothing_flags = SNUG_FIT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	dog_fashion = /datum/dog_fashion/head/dragoon
	sound_vary = TRUE
	equip_sound = 'sound/items/handling/helmet/helmet_equip1.ogg'
	pickup_sound = 'sound/items/handling/helmet/helmet_pickup1.ogg'
	drop_sound = 'sound/items/handling/helmet/helmet_drop1.ogg'
