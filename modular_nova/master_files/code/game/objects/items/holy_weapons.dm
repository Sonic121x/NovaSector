/datum/atom_skin/chaplain_bland
	abstract_type = /datum/atom_skin/chaplain_bland

/datum/atom_skin/chaplain_bland/knight_generic
	preview_name = "Basic"
	new_icon_state = "knight_generic"

/datum/atom_skin/chaplain_bland/knight_winged
	preview_name = "Winged"
	new_icon_state = "knight_winged"

/datum/atom_skin/chaplain_bland/knight_horned
	preview_name = "Horned"
	new_icon_state = "knight_horned"

/obj/item/clothing/head/helmet/chaplain/bland
	icon = 'modular_nova/master_files/icons/obj/clothing/head/chaplain.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head/chaplain.dmi'
	name = "十字军头盔"
	desc = "Helfen, Wehren, Heilen."
	icon_state = "knight_generic"

/obj/item/clothing/head/helmet/chaplain/bland/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/chaplain_bland)

/datum/atom_skin/templar_generic
	abstract_type = /datum/atom_skin/templar_generic

/datum/atom_skin/templar_generic/knight_generic
	preview_name = "Basic"
	new_icon_state = "knight_generic"

/datum/atom_skin/templar_generic/knight_teutonic
	preview_name = "Teutonic"
	new_icon_state = "knight_teutonic"

/datum/atom_skin/templar_generic/knight_hospitaller
	preview_name = "Hospitaller"
	new_icon_state = "knight_hospitaller"

/obj/item/clothing/suit/chaplainsuit/armor/templar/generic
	icon = 'modular_nova/master_files/icons/obj/clothing/suits/chaplain.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suits/chaplain.dmi'
	desc = "保护弱小与无助者，为荣誉与荣耀而生，为所有人的福祉而战！"
	icon_state = "knight_generic"

/obj/item/clothing/suit/chaplainsuit/armor/templar/generic/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/templar_generic)

/obj/item/storage/box/holy/knight
	name = "骑士装备包"

/obj/item/storage/box/holy/knight/PopulateContents()
	new /obj/item/clothing/head/helmet/chaplain/bland(src)
	new /obj/item/clothing/suit/chaplainsuit/armor/templar/generic(src)

//make chaplain version w/ unique sprite?
/obj/item/clothing/suit/hooded/cultlain_robe
	name = "古老长袍"
	desc = "一套破旧、布满灰尘的长袍。"
	icon = 'icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'icons/mob/clothing/suits/armor.dmi'
	icon_state = "cultrobes"
	inhand_icon_state = "cultrobes"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	armor_type = /datum/armor/chaplainsuit_armor
	allowed = list(/obj/item/book/bible, /obj/item/nullrod, /obj/item/reagent_containers/cup/glass/bottle/holywater, /obj/item/storage/fancy/candle_box, /obj/item/flashlight/flare/candle, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman)
	hoodtype = /obj/item/clothing/head/hooded/cultlain_hood

/obj/item/clothing/head/hooded/cultlain_hood
	name = "古老兜帽"
	desc = "一顶撕裂、沾满灰尘的兜帽。"
	icon_state = "culthood"
	icon = 'icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'icons/mob/clothing/head/helmet.dmi'
	body_parts_covered = HEAD
	flags_inv = HIDEFACE|HIDEHAIR|HIDEEARS
	flags_cover = HEADCOVERSEYES
	armor_type = /datum/armor/chaplainsuit_armor

/obj/item/storage/box/holy/narsian
	name = "古老装备包"

/obj/item/storage/box/holy/narsian/PopulateContents()
	new /obj/item/clothing/suit/hooded/cultlain_robe(src)
	new /obj/item/clothing/shoes/cult/alt(src)

/obj/item/nullrod/cultdagger
	name = "仪式匕首"
	desc = "一把据称曾被某个邪恶团体使用过的奇异匕首。"
	icon = 'icons/obj/weapons/khopesh.dmi'
	icon_state = "render"
	inhand_icon_state = "cultdagger"
	worn_icon_state = "render"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	special_desc_requirement = EXAMINE_CHECK_JOB
	special_desc_jobs = list(JOB_CHAPLAIN)
	special_desc = "Activate it to receive the language of a forgotten cult."
	var/narsian = FALSE

/obj/item/nullrod/cultdagger/attack_self(mob/user)
	if(!narsian && user.mind && (user.mind.holy_role))
		to_chat(user, span_cult_large("以血为语..."))
		user.grant_language(/datum/language/narsie, source = LANGUAGE_MIND)
		special_desc_requirement = NONE // No point in keeping something that can't no longer be used
		narsian = TRUE

/obj/item/nullrod/claymore/darkblade
	special_desc_requirement = EXAMINE_CHECK_JOB
	special_desc_jobs = list(JOB_CHAPLAIN)
	special_desc = "Activate it to receive the language of a forgotten cult."
	var/narsian = FALSE

/obj/item/nullrod/claymore/darkblade/attack_self(mob/user)
	if(!narsian && user.mind && (user.mind.holy_role))
		to_chat(user, span_cult_large("以血为语..."))
		user.grant_language(/datum/language/narsie, source = LANGUAGE_MIND)
		special_desc_requirement = NONE // No point in keeping something that can't no longer be used
		narsian = TRUE

/obj/item/nullrod/spear
	special_desc_requirement = EXAMINE_CHECK_JOB
	special_desc_jobs = list(JOB_CHAPLAIN)
	special_desc = "Activate it to receive the language of a forgotten cult."
	var/ratvarian = FALSE

/obj/item/nullrod/spear/attack_self(mob/user)
	if(ratvarian)
		return ..()
	else if(user.mind?.holy_role)
		to_chat(user, span_bigbrass("齿轮的声响渗透进你的脑海..."))
		user.grant_language(/datum/language/ratvar, source = LANGUAGE_MIND)
		special_desc_requirement = NONE // No point in keeping something that can't no longer be used
		ratvarian = TRUE

/obj/item/nullrod/rosary
	name = "念珠"
	desc = "一套在太空诸多传统宗教中使用的念珠。"
	icon = 'modular_nova/modules/chaplain/icons/holy_weapons.dmi'
	icon_state = "rosary"
	worn_icon_state = "nullrod"
	force = 4
	throwforce = 0
	attack_verb_simple = list("whipped", "repented", "lashed", "flagellated")
	attack_verb_continuous = list("whipped", "repented", "lashed", "flagellated")
	slot_flags = ITEM_SLOT_BELT
	var/praying = FALSE
	var/deity_name = "Coderbus" // This is the default, hopefully won't actually appear if the religion subsystem is running properly

/obj/item/nullrod/rosary/Initialize(mapload)
	.=..()
	if(GLOB.deity)
		deity_name = GLOB.deity

/obj/item/nullrod/rosary/attack(mob/living/target, mob/living/user, params)
	if(!user.mind || !user.mind.holy_role)
		balloon_alert(user, "不够神圣！")
		return
	if(user.combat_mode)
		return ..()
	if(praying)
		balloon_alert(user, "已在使用中！")
		return

	user.visible_message(span_info("[user]跪了下来[target == user ? null : " next to [target]"]，开始向[deity_name]祈祷。"), \
		span_info("你跪了下来[target == user ? null : " next to [target]"]，开始向[deity_name]祈祷。"))

	praying = TRUE
	if(do_after(user, 5 SECONDS, target = target))
		target.reagents?.add_reagent(/datum/reagent/water/holywater, 5)
		to_chat(target, span_notice("[user] 向 [deity_name] 的祈祷缓解了你的痛苦！"))
		var/need_mob_update
		need_mob_update += target.adjust_tox_loss(-5, updating_health = FALSE, forced = TRUE)
		need_mob_update += target.adjust_oxy_loss(-5, updating_health = FALSE)
		need_mob_update += target.adjust_brute_loss(-5, updating_health = FALSE)
		need_mob_update += target.adjust_fire_loss(-5, updating_health = FALSE)
		if(need_mob_update)
			target.updatehealth()
		praying = FALSE
	else
		balloon_alert(user, "被打断了！")
		praying = FALSE

/obj/item/nullrod/scythe/sickle
	name = "受诅咒的镰刀"
	desc = "一把绿色的新月形刀刃，装饰着一只装饰性的眼睛。瞳孔已经褪色..."
	icon = 'icons/obj/weapons/khopesh.dmi'
	icon_state = "eldritch_blade"
	inhand_icon_state = "eldritch_blade"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	slot_flags = ITEM_SLOT_BELT
	sharpness = SHARP_EDGED
	w_class = WEIGHT_CLASS_NORMAL
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "rends")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "rend")

/obj/item/nullrod/scythe/sickle/void
	name = "水晶镰刀"
	desc = "由透明水晶制成，刀刃微微折射着光线。如此接近却又无法以这种形态触及的纯净。"
	icon_state = "void_blade"
	inhand_icon_state = "void_blade"
	worn_icon_state = "dark_blade"
