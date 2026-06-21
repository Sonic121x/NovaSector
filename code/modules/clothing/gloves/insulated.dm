/obj/item/clothing/gloves/color
	abstract_type = /obj/item/clothing/gloves/color
	dying_key = DYE_REGISTRY_GLOVES
	greyscale_colors = null

/obj/item/clothing/gloves/color/yellow
	desc = "这些手套提供电击防护。"
	name = "绝缘手套"
	icon_state = "yellow"
	inhand_icon_state = "ygloves"
	siemens_coefficient = 0
	armor_type = /datum/armor/color_yellow
	resistance_flags = NONE
	custom_price = PAYCHECK_CREW * 10
	custom_premium_price = PAYCHECK_COMMAND * 6
	cut_type = /obj/item/clothing/gloves/cut
	equip_sound = 'sound/items/equip/glove_equip.ogg'

/obj/item/clothing/gloves/color/yellow/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, 10)

/obj/item/clothing/gloves/color/yellow/apply_fantasy_bonuses(bonus)
	. = ..()
	if(bonus >= 10)
		RemoveElement(/datum/element/adjust_fishing_difficulty)

/obj/item/clothing/gloves/color/yellow/remove_fantasy_bonuses(bonus)
	if(bonus >= 10)
		RemoveElement(/datum/element/adjust_fishing_difficulty)
		AddElement(/datum/element/adjust_fishing_difficulty, 10)
	return ..()

/datum/armor/color_yellow
	bio = 50

/obj/item/clothing/gloves/color/yellow/heavy
	name = "陶瓷内衬绝缘手套"
	desc = "标准绝缘手套的廉价版本，使用内部陶瓷衬里来弥补劣质橡胶材料的不足。额外的重量使它们使用起来更笨重。"
	slowdown = 1
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/toy/sprayoncan
	name = "喷涂式绝缘涂敷器"
	desc = "我们空间站今天面临的头号问题是什么？"
	icon = 'icons/obj/clothing/gloves.dmi'
	icon_state = "sprayoncan"

/obj/item/toy/sprayoncan/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!iscarbon(interacting_with))
		return NONE
	var/mob/living/carbon/C = interacting_with
	var/mob/living/carbon/U = user
	var/success = C.equip_to_slot_if_possible(new /obj/item/clothing/gloves/color/yellow/sprayon, ITEM_SLOT_GLOVES, qdel_on_fail = TRUE, disable_warning = TRUE)
	if(success)
		if(C == user)
			C.visible_message(span_notice("[U] 往自己手上喷了闪亮的橡胶！"))
		else
			C.visible_message(span_warning("[U] 往 [C] 的手上喷了闪亮的橡胶！"))
	else
		C.visible_message(span_warning("橡胶没能粘在 [C] 的手上！"))
	return ITEM_INTERACT_SUCCESS

/obj/item/clothing/gloves/color/yellow/sprayon
	desc = "你打算怎么把它们弄下来，书呆子？"
	name = "喷涂式绝缘手套"
	icon_state = "sprayon"
	inhand_icon_state = null
	item_flags = DROPDEL
	clothing_traits = list(TRAIT_CHUNKYFINGERS)
	armor_type = /datum/armor/none
	resistance_flags = ACID_PROOF
	var/charges_remaining = 10

/obj/item/clothing/gloves/color/yellow/sprayon/Initialize(mapload)
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, INNATE_TRAIT)

/obj/item/clothing/gloves/color/yellow/sprayon/equipped(mob/user, slot)
	. = ..()
	RegisterSignal(user, COMSIG_LIVING_SHOCK_PREVENTED, PROC_REF(use_charge))
	RegisterSignal(src, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(use_charge))

/obj/item/clothing/gloves/color/yellow/sprayon/proc/use_charge()
	SIGNAL_HANDLER

	. = NONE

	charges_remaining--
	if(charges_remaining <= 0)
		var/turf/location = get_turf(src)
		location.visible_message(span_warning("[src] 碎裂[p_s()] 成虚无。")) // just like my dreams after working with .dm
		qdel(src)

	. |= COMPONENT_CLEANED

/obj/item/clothing/gloves/color/fyellow                             //Cheap Chinese Crap
	desc = "这些手套是备受追捧的正品的廉价仿制品——这肯定不会出什么岔子。"
	name = "廉价绝缘手套"
	icon_state = "yellow"
	inhand_icon_state = "ygloves"
	greyscale_colors = null
	siemens_coefficient = 1 //Set to a default of 1, gets overridden in Initialize()
	armor_type = /datum/armor/color_fyellow
	resistance_flags = NONE
	cut_type = /obj/item/clothing/gloves/cut

/datum/armor/color_fyellow
	bio = 25

/obj/item/clothing/gloves/color/fyellow/Initialize(mapload)
	. = ..()
	siemens_coefficient = pick(0,0.5,0.5,0.5,0.5,0.75,1.5)

/obj/item/clothing/gloves/color/fyellow/examine_tags(mob/user)
	. = ..()
	// Pretend we're always insulated
	if (.["partially insulated"])
		. -= "partially insulated"
	.["insulated"] = "It is made from a robust electrical insulator and will block any electricity passing through it!"

/obj/item/clothing/gloves/color/fyellow/old
	desc = "老旧磨损的绝缘手套，希望它们还能用。"
	name = "磨损的绝缘手套"

/obj/item/clothing/gloves/color/fyellow/old/Initialize(mapload)
	. = ..()
	siemens_coefficient = pick(0,0,0,0.5,0.5,0.5,0.75)

/obj/item/clothing/gloves/cut
	desc = "这些手套本可以保护穿戴者免受电击……如果手指部分被覆盖的话。"
	name = "无指绝缘手套"
	icon_state = "yellowcut"
	inhand_icon_state = "ygloves"
	greyscale_colors = null
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH)

/obj/item/clothing/gloves/cut/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -5)

/obj/item/clothing/gloves/cut/heirloom
	desc = "这是你曾祖父很久以前从工程部偷来的旧手套。它们最近经历了一些艰难时刻。"

/obj/item/clothing/gloves/chief_engineer
	desc = "这双手套提供了出色的隔热和电绝缘性能。"
	name = "高级绝缘手套"
	icon_state = "ce_insuls"
	inhand_icon_state = null
	greyscale_colors = null
	siemens_coefficient = 0
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE

/obj/item/clothing/gloves/chief_engineer/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -6)
