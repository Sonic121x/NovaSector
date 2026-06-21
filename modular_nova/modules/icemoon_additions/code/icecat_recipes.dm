/obj/item/anointing_oil
	name = "血树脂涂油"
	desc = "于是，赫尔加·刀臂向炉心宣告，所有为野兽命名的族人，都应以征服与鲜血来完成此仪式。"
	icon = 'modular_nova/modules/primitive_catgirls/icons/objects.dmi'
	icon_state = "anointingbloodresin"
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY

	var/being_used = FALSE

/obj/item/anointing_oil/attack(mob/living/target_mob, mob/living/user, params)
	if (!is_species(user, /datum/species/human/felinid/primitive))
		to_chat(user, span_warning("你完全不知道这恶心的混合物是做什么用的。"))
		return
	if(being_used || !ismob(target_mob)) //originally this was going to check if the mob was friendly, but if an icecat wants to name some terror mob while it's tearing chunks out of them, why not?
		return
	if(target_mob.ckey)
		to_chat(user, span_warning("你绝不会羞辱如此聪慧的生物，剥夺它为自己选择名字的权利。"))
		return

	if(try_anoint(target_mob, user))
		qdel(src)
	else
		being_used = FALSE

/obj/item/anointing_oil/proc/try_anoint(mob/living/target_mob, mob/living/user)
	being_used = TRUE

	var/new_name = sanitize_name(tgui_input_text(user, "向所有族人宣告这头野兽的新名字。", "输入名字", target_mob.name, max_length = MAX_NAME_LEN))

	if(!new_name || QDELETED(src) || QDELETED(target_mob) || new_name == target_mob.name || !target_mob.Adjacent(user))
		being_used = FALSE
		return FALSE

	target_mob.visible_message(span_notice("[user]俯身，在[target_mob]身上涂抹了两道闪亮的血树脂条纹，然后带着仪式的目的直起身来..."))
	user.say("Let the ice know you forevermore as +[new_name]+.")

	user.log_message("used [src] on [target_mob], renaming it to [new_name].", LOG_GAME)

	target_mob.name = new_name

	//give the stupid dog zoomies from getting named
	if(istype(target_mob, /mob/living/basic/mining/wolf))
		target_mob.emote("awoo")
		target_mob.emote("spin")

	return TRUE

/obj/item/anointing_oil/examine(mob/user)
	. = ..()
	if(is_species(user, /datum/species/human/felinid/primitive))
		. += span_info("将此物用于当地野生动物，即可为它们命名。")

/datum/crafting_recipe/anointing_oil
	name = "血树脂涂油"
	category = CAT_MISC
	//recipe given to icecats as part of their spawner/team setting
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

	reqs = list(
		/datum/reagent/consumable/liquidgibs = 20,
		/datum/reagent/blood = 20,
	)

	result = /obj/item/anointing_oil

/obj/item/clothing/suit/armor/forging_plate_armor/hearthkin
	name = "手工炉心族护甲"
	desc = "一件明显由炉心族匠人精心打造的护甲。配有皮革肩垫，内衬锁子甲。"
	icon_state = "chained_leather_armor"
	icon = 'modular_nova/modules/primitive_catgirls/icons/objects.dmi'
	worn_icon = 'modular_nova/modules/primitive_catgirls/icons/clothing_greyscale.dmi'
	body_parts_covered = GROIN|CHEST

/datum/crafting_recipe/handcrafted_hearthkin_armor
	name = "手工炉心族护甲"
	category = CAT_CLOTHING

	//recipe given to icecats as part of their spawner/team setting
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

	reqs = list(
		/obj/item/forging/complete/chain = 4,
		/obj/item/stack/sheet/leather = 2,
	)

	result = /obj/item/clothing/suit/armor/forging_plate_armor/hearthkin

// Hearthkin Exclusive Beds
/obj/structure/bed/double/pelt
	name = "白色毛皮床"
	desc = "一张奢华的双人床，由白色狼皮制成。"
	icon_state = "pelt_bed_white"
	icon = 'modular_nova/modules/tribal_extended/icons/tribal_beds.dmi'
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 90
	resistance_flags = FLAMMABLE
	max_integrity = 100
	integrity_failure = 0.35
	max_buckled_mobs = 2
	/// What material this bed is made of
	build_stack_type = /obj/item/stack/sheet/sinew/wolf
	/// How many mats to drop when deconstructed
	build_stack_amount = 4
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 4)

/obj/structure/bed/double/pelt/atom_deconstruct(disassembled = TRUE)
	. = ..()
	new /obj/item/stack/sheet/mineral/wood(loc, build_stack_amount)

/datum/crafting_recipe/white_pelt_bed
	name = "白色毛皮床"
	category = CAT_FURNITURE
	//recipe given to icecats as part of their spawner/team setting
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND

	reqs = list(
		/obj/item/stack/sheet/sinew/wolf = 4,
		/obj/item/stack/sheet/mineral/wood = 4,
	)

	result = /obj/structure/bed/double/pelt

/obj/structure/bed/double/pelt/black
	name = "黑色毛皮床"
	desc = "一张奢华的双人床，由黑色狼皮制成。"
	icon_state = "pelt_bed_black"
	icon = 'modular_nova/modules/tribal_extended/icons/tribal_beds.dmi'
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 4)

/datum/crafting_recipe/black_pelt_bed
	name = "黑色毛皮床"
	category = CAT_FURNITURE
	//recipe given to icecats as part of their spawner/team setting
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND

	reqs = list(
		/obj/item/stack/sheet/sinew/wolf = 4,
		/obj/item/stack/sheet/mineral/wood = 4,
	)

	result = /obj/structure/bed/double/pelt/black

// Hearthkin exclusive object to make their special lungs.
/obj/item/frozen_breath
	name = "冻结吐息"
	desc = "一种奇怪的酿造物，闻起来有薄荷味，触感极其冰冷。据传，一位冷酷的女巫设法制作了此物，用以治愈她同族的呼吸。"
	icon = 'modular_nova/modules/primitive_catgirls/icons/objects.dmi'
	icon_state = "frozenbreath"
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY

/obj/item/frozen_breath/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if (!is_species(user, /datum/species/human/felinid/primitive))
		to_chat(user, span_warning("你不知道如何使用这种冰冻合剂。"))
		return

	if(istype(interacting_with, /obj/item/organ/lungs))
		var/obj/item/organ/lungs/target_lungs = interacting_with
		if(IS_ROBOTIC_ORGAN(target_lungs))
			user.balloon_alert(user, "肺部必须是有机的！")
			return
		var/location = get_turf(target_lungs)
		playsound(location, 'sound/effects/slosh.ogg', 25, TRUE)
		user.visible_message(span_notice("[user] 将一种奇怪的蓝色液体倒在一副肺部上。血肉开始闪烁着诡异的青色光芒，就在你眼前开始转变！"),
			span_notice("回想起肺部变形仪式的指示，你将液体倒在器官的肉质上。很快，肺部发出柔和的青色光芒，随后光芒暗淡，就在你眼前改变了形态！"))
		var/obj/item/organ/lungs/icebox_adapted/new_lungs = new(location)
		new_lungs.damage = target_lungs.damage
		qdel(target_lungs)
		qdel(src)

/obj/item/frozen_breath/examine(mob/user)
	. = ..()
	if(is_species(user, /datum/species/human/felinid/primitive))
		. += span_info("将其用于一副有机肺部，可将其转化为强韧肺部。这将移除旧肺部的任何其他特殊特性（如果存在的话）。")

/datum/crafting_recipe/frozen_breath
	name = "冻结吐息"
	category = CAT_MISC
	//recipe given to icecats as part of their spawner/team setting
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

	reqs = list(
		/datum/reagent/consumable/frostoil = 50,
		/datum/reagent/medicine/c2/synthflesh = 50,
	)

	result = /obj/item/frozen_breath
