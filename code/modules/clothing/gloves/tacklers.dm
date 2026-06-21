/obj/item/clothing/gloves/tackler
	name = "增强型回收手套"
	desc = "能够操纵佩戴者手部血管的特殊手套，赋予他们一头撞向墙壁并一跃扑倒逃跑罪犯的能力。"
	icon_state = "tackle"
	inhand_icon_state = null
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	resistance_flags = NONE
	custom_premium_price = PAYCHECK_COMMAND * 3.5
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH,TRAIT_FAST_CUFFING)
	equip_sound = 'sound/items/equip/glove_equip.ogg'
	/// For storing our tackler datum so we can remove it after
	var/datum/component/tackler
	/// See: [/datum/component/tackler/var/stamina_cost]
	var/tackle_stam_cost = 25
	/// See: [/datum/component/tackler/var/base_knockdown]
	var/base_knockdown = 1 SECONDS
	/// See: [/datum/component/tackler/var/range]
	var/tackle_range = 4
	/// See: [/datum/component/tackler/var/min_distance]
	var/min_distance = 0
	/// See: [/datum/component/tackler/var/speed]
	var/tackle_speed = 1
	/// See: [/datum/component/tackler/var/skill_mod]
	var/skill_mod = 1
	///How much these gloves affect fishing difficulty
	var/fishing_modifier = -7

/obj/item/clothing/gloves/tackler/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, fishing_modifier) //fishing tackle equipment (ba dum tsh)

/obj/item/clothing/gloves/tackler/Destroy()
	tackler = null
	return ..()

/obj/item/clothing/gloves/tackler/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	if(slot & ITEM_SLOT_GLOVES)
		var/mob/living/carbon/human/H = user
		tackler = H.AddComponent(/datum/component/tackler, stamina_cost=tackle_stam_cost, base_knockdown = base_knockdown, range = tackle_range, speed = tackle_speed, skill_mod = skill_mod, min_distance = min_distance)

/obj/item/clothing/gloves/tackler/dropped(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_item_by_slot(ITEM_SLOT_GLOVES) == src)
		QDEL_NULL(tackler)

/obj/item/clothing/gloves/tackler/dolphin
	name = "海豚手套"
	desc = "流线型的抓握手套，在施展擒拿技巧方面效果较差，但能更有效的让使用者在走廊上一路滑行和制造事故."
	icon_state = "tackledolphin"
	inhand_icon_state = null

	tackle_stam_cost = 15
	base_knockdown = 0.5 SECONDS
	tackle_range = 5
	tackle_speed = 2
	min_distance = 2
	skill_mod = -2
	fishing_modifier = -10

/obj/item/clothing/gloves/tackler/combat
	name = "大猩猩手套"
	desc = "经过大量加固的高质量战斗手套，能让使用者在近身搏斗中占有优势，虽然用起来比普通的抓握手套还要费力.这款手套还防火！"
	icon_state = "gorilla"
	inhand_icon_state = null

	tackle_stam_cost = 30
	base_knockdown = 1.25 SECONDS
	tackle_range = 5
	skill_mod = 2

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE

/obj/item/clothing/gloves/tackler/combat/insulated
	name = "游击队手套"
	desc = "优质的战斗手套，适合执行扑击擒拿和抵御电击."
	icon_state = "guerrilla"
	siemens_coefficient = 0
	armor_type = /datum/armor/combat_insulated

/datum/armor/combat_insulated
	bio = 50

/obj/item/clothing/gloves/tackler/rocket
	name = "火箭手套"
	desc = "高风险高回报的终极选择，非常适合在需要在五十英尺的距离内阻止犯罪分子或不惜一头撞死墙上的情况下使用.被大多数顺向的烤盘足球和橄榄球联赛禁止使用。"
	icon_state = "tacklerocket"
	inhand_icon_state = null

	tackle_stam_cost = 50
	base_knockdown = 2 SECONDS
	tackle_range = 10
	min_distance = 7
	tackle_speed = 6
	skill_mod = 7

/obj/item/clothing/gloves/tackler/offbrand
	name = "简易抓握手套"
	desc = "外观破旧的无指手套，用胶带包裹着.小心戴着这些手套的人，因为他们显然毫无羞耻心，也没有任何可失去的东西."
	icon_state = "fingerless"
	inhand_icon_state = null
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH)
	tackle_stam_cost = 30
	base_knockdown = 1.75 SECONDS
	min_distance = 2
	skill_mod = -1
	fishing_modifier = -5

/obj/item/clothing/gloves/tackler/football
	name = "足球手套"
	desc = "足球运动员的手套！教他们如何像专业人士一样铲球。"
	icon_state = "tackle_gloves"
	inhand_icon_state = null
	fishing_modifier = -4
