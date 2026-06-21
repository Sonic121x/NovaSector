// *************************************
// Hydroponics Tools
// *************************************

/obj/item/reagent_containers/spray/weedspray // -- Skie
	desc = "一种有毒混合物，可以以水雾形式喷出，清除小型杂草。"
	icon = 'icons/obj/service/hydroponics/equipment.dmi'
	name = "除草喷雾"
	icon_state = "weedspray"
	inhand_icon_state = "spraycan"
	worn_icon_state = "spraycan"
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	volume = 100
	list_reagents = list(/datum/reagent/toxin/plantbgone/weedkiller = 100)

/obj/item/reagent_containers/spray/weedspray/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]正在猛吸[src]！看起来[user.p_theyre()]试图自杀！"))
	return TOXLOSS

/obj/item/reagent_containers/spray/pestspray // -- Skie
	desc = "这是某种杀虫喷雾！<I>请勿吸入！</I>"
	icon = 'icons/obj/service/hydroponics/equipment.dmi'
	name = "杀虫喷雾"
	icon_state = "pestspray"
	inhand_icon_state = "plantbgone"
	worn_icon_state = "spraycan"
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	volume = 100
	list_reagents = list(/datum/reagent/toxin/pestkiller = 100)

/obj/item/reagent_containers/spray/pestspray/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]正在猛吸[src]！看起来[user.p_theyre()]试图自杀！"))
	return TOXLOSS

/obj/item/cultivator
	name = "小耙子"
	desc = "用来除草或者挠痒."
	icon = 'icons/obj/service/hydroponics/equipment.dmi'
	icon_state = "cultivator"
	inhand_icon_state = "cultivator"
	icon_angle = -135
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	force = 5
	throwforce = 7
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*0.5)
	attack_verb_continuous = list("slashes", "slices", "cuts", "claws")
	attack_verb_simple = list("slash", "slice", "cut", "claw")
	hitsound = 'sound/items/weapons/bladeslice.ogg'

/obj/item/cultivator/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] is scratching [user.p_their()] back as hard as [user.p_they()] can with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return BRUTELOSS

/obj/item/cultivator/rake
	name = "耙子"
	icon_state = "rake"
	icon_angle = -45
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("slashes", "slices", "bashes", "claws")
	attack_verb_simple = list("slash", "slice", "bash", "claw")
	hitsound = null
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 5)
	resistance_flags = FLAMMABLE
	flags_1 = NONE

/obj/item/cultivator/rake/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/item/cultivator/rake/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/H = AM
	if(has_gravity(loc) && HAS_TRAIT(H, TRAIT_CLUMSY) && !H.resting)
		H.set_confusion_if_lower(10 SECONDS)
		H.Stun(20)
		playsound(src, 'sound/items/weapons/punch4.ogg', 50, TRUE)
		H.visible_message(span_warning("[H]踩到[src]导致把手正砸在[H.p_them()]脸上！"), \
						  span_userdanger("你踩到[src]导致把手正砸在你脸上！"))

/obj/item/cultivator/cyborg
	name = "机械人耕耘器"
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "sili_cultivator"
	icon_angle = 0

/obj/item/hatchet
	name = "短柄斧"
	desc = "一把锋利的斧头，其金属柄较短，表面覆盖着纤维材质的护套。它有着悠久的砍伐物品的历史，如今则被用于劈木头。"
	icon = 'icons/obj/service/hydroponics/equipment.dmi'
	icon_state = "hatchet"
	inhand_icon_state = "hatchet"
	icon_angle = -135
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	force = 12
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 15
	throw_speed = 4
	throw_range = 7
	embed_type = /datum/embedding/hatchet
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*7.5)
	attack_verb_continuous = list("chops", "tears", "lacerates", "cuts")
	attack_verb_simple = list("chop", "tear", "lacerate", "cut")
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED

/datum/embedding/hatchet
	pain_mult = 4
	embed_chance = 35
	fall_chance = 10

/obj/item/hatchet/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, \
	speed = 7 SECONDS, \
	effectiveness = 100, \
	)

/obj/item/hatchet/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]正用[src]砍向[user.p_them()]自己！看起来[user.p_theyre()]试图自杀！"))
	playsound(src, 'sound/items/weapons/bladeslice.ogg', 50, TRUE, -1)
	return BRUTELOSS

/obj/item/hatchet/wooden
	desc = "一把粗制的斧头，斧头的柄是用短木头制成的。"
	icon_state = "woodhatchet"
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 1)
	resistance_flags = FLAMMABLE
	flags_1 = NONE

/obj/item/hatchet/cyborg
	name = "机械人短柄斧"
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "sili_hatchet"
	icon_angle = 0

/* NOVA EDIT Start - Modularization and New Scythes
/obj/item/scythe
	name = "scythe"
	desc = "A sharp and curved blade on a long fibremetal handle, this tool makes it easy to reap what you sow."
	icon = 'icons/obj/service/hydroponics/equipment.dmi'
	icon_state = "scythe0"
	inhand_icon_state = "scythe0"
	icon_angle = -45
	lefthand_file = 'icons/mob/inhands/weapons/polearms_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/polearms_righthand.dmi'
	force = 15
	throwforce = 5
	throw_speed = 2
	throw_range = 3
	w_class = WEIGHT_CLASS_BULKY
	obj_flags = CONDUCTS_ELECTRICITY
	armour_penetration = 20
	wound_bonus = 10
	slot_flags = ITEM_SLOT_BACK
	attack_verb_continuous = list("chops", "slices", "cuts", "reaps")
	attack_verb_simple = list("chop", "slice", "cut", "reap")
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED
	item_flags = CRUEL_IMPLEMENT //maybe they want to use it in surgery
	var/swiping = FALSE

/obj/item/scythe/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, speed = 9 SECONDS, effectiveness = 105)
	AddComponent(/datum/component/bane, affected_biotypes = MOB_PLANT, damage_multiplier = 1.5)
	AddComponent(/datum/component/walking_aid)

/obj/item/scythe/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] is beheading [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		var/obj/item/bodypart/BP = C.get_bodypart(BODY_ZONE_HEAD)
		if(BP)
			BP.drop_limb()
			playsound(src, SFX_DESECRATION ,50, TRUE, -1)
	return BRUTELOSS

/obj/item/scythe/pre_attack(atom/target, mob/living/user, list/modifiers, list/attack_modifiers)
	if(!istype(target, /obj/structure/alien/resin/flower_bud) && !istype(target, /obj/structure/spacevine))
		return ..()
	if(swiping || get_turf(target) == get_turf(user))
		return ..()
	var/turf/user_turf = get_turf(user)
	var/dir_to_target = get_dir(user_turf, get_turf(target))
	swiping = TRUE
	var/static/list/scythe_slash_angles = list(0, 45, 90, -45, -90)
	for(var/i in scythe_slash_angles)
		var/turf/adjacent_turf = get_step(user_turf, turn(dir_to_target, i))
		for(var/obj/structure/spacevine/vine in adjacent_turf)
			if(user.Adjacent(vine))
				melee_attack_chain(user, vine)
		for(var/obj/structure/alien/resin/flower_bud/flower in adjacent_turf)
			if(user.Adjacent(flower))
				melee_attack_chain(user, flower)
	swiping = FALSE
	return TRUE
*/

/obj/item/secateurs
	name = "修枝剪"
	desc = "这是用于从植物上切取接穗或改变荚果人外观的工具。"
	desc_controls = "Right-click to stylize podperson hair or other plant features!"
	icon = 'icons/obj/service/hydroponics/equipment.dmi'
	icon_state = "secateurs"
	inhand_icon_state = null
	worn_icon_state = "cutters"
	icon_angle = -135
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	force = 5
	throwforce = 6
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	custom_materials = list(/datum/material/iron= SHEET_MATERIAL_AMOUNT*2)
	attack_verb_continuous = list("slashes", "slices", "cuts", "claws")
	attack_verb_simple = list("slash", "slice", "cut", "claw")
	hitsound = 'sound/items/weapons/bladeslice.ogg'

///Catch right clicks so we can stylize!
/obj/item/secateurs/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(user.combat_mode)
		return NONE

	restyle(interacting_with, user)
	return ITEM_INTERACT_SUCCESS

///Send a signal to whatever we clicked and ask them if they wanna be PLANT RESTYLED YEAAAAAAAH
/obj/item/secateurs/proc/restyle(atom/target, mob/living/user)
	SEND_SIGNAL(target, COMSIG_ATOM_RESTYLE, user, target, user.zone_selected, EXTERNAL_RESTYLE_PLANT, 6 SECONDS)

/obj/item/secateurs/cyborg
	name = "机械人修枝剪"
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "sili_secateur"
	icon_angle = 0

/obj/item/geneshears
	name = "植物学遗传修饰剪"
	desc = "一把高科技、高保真度的植物修剪剪刀，能够剪除植物的遗传特征."
	icon = 'icons/obj/service/hydroponics/equipment.dmi'
	icon_state = "genesheers"
	inhand_icon_state = null
	worn_icon_state = "cutters"
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	force = 10
	throwforce = 8
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2, /datum/material/uranium=HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/gold=SMALL_MATERIAL_AMOUNT*5)
	attack_verb_continuous = list("slashes", "slices", "cuts")
	attack_verb_simple = list("slash", "slice", "cut")
	hitsound = 'sound/items/weapons/bladeslice.ogg'

// *************************************
// Nutrient defines for hydroponics
// *************************************


/obj/item/reagent_containers/cup/bottle/nutrient
	name = "一瓶肥料（nutrient）"
	volume = 50
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(1,2,5,10,15,25,50)

/obj/item/reagent_containers/cup/bottle/nutrient/Initialize(mapload)
	. = ..()
	pixel_x = base_pixel_x + rand(-5, 5)
	pixel_y = base_pixel_y + rand(-5, 5)


/obj/item/reagent_containers/cup/bottle/nutrient/ez
	name = "一瓶E-Z-简单肥（E-Z-Nutrient）"
	desc = "含有一种肥料，会引发轻微的变异，并植物使每收获一次都会生长。"
	list_reagents = list(/datum/reagent/plantnutriment/eznutriment = 50)

/obj/item/reagent_containers/cup/bottle/nutrient/l4z
	name = "一瓶L4变异肥"
	desc = "含有一种肥料，这种肥料能轻微地治愈植物，但会使植物在世代繁衍过程中产生严重的变异。"
	list_reagents = list(/datum/reagent/plantnutriment/left4zednutriment = 50)

/obj/item/reagent_containers/cup/bottle/nutrient/rh
	name = "一瓶强健丰收肥"
	desc = "含有这样一种肥料，它能提高植物的产量，同时又能逐渐防止其发生变异。"
	list_reagents = list(/datum/reagent/plantnutriment/robustharvestnutriment = 50)

/obj/item/reagent_containers/cup/bottle/nutrient/empty
	name = "瓶子"

/obj/item/reagent_containers/cup/bottle/killer
	volume = 30
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = list(1,2,5)

/obj/item/reagent_containers/cup/bottle/killer/weedkiller
	name = "一瓶除草剂"
	desc = "装有除草剂。"
	list_reagents = list(/datum/reagent/toxin/plantbgone/weedkiller = 30)

/obj/item/reagent_containers/cup/bottle/killer/pestkiller
	name = "一瓶杀虫喷雾"
	desc = "装有杀虫剂。"
	list_reagents = list(/datum/reagent/toxin/pestkiller = 30)
