/**
 * Base cult armor
 * Has decent defense stats, protects against temperature changes.
 * Currently a drop on Lavaland, hence the lack of cool stuff.
 */
/obj/item/clothing/suit/hooded/cultrobes
	name = "远古教徒长袍"
	desc = "一套破旧、布满灰尘的长袍。内衬有奇怪的文字。"
	icon_state = "cultrobes"
	icon = 'icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'icons/mob/clothing/suits/armor.dmi'
	inhand_icon_state = "cultrobes"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	allowed = list(/obj/item/tome, /obj/item/melee/cultblade, /obj/item/melee/sickly_blade/cursed)
	armor_type = /datum/armor/hooded_cultrobes
	flags_inv = HIDEJUMPSUIT
	cold_protection = CHEST|GROIN|LEGS|ARMS
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|ARMS
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	hoodtype = /obj/item/clothing/head/hooded/cult_hoodie

/datum/armor/hooded_cultrobes
	melee = 40
	bullet = 30
	laser = 40
	energy = 40
	bomb = 25
	bio = 10
	fire = 10
	acid = 10

/obj/item/clothing/head/hooded/cult_hoodie
	name = "远古教徒兜帽"
	icon = 'icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'icons/mob/clothing/head/helmet.dmi'
	icon_state = "culthood"
	inhand_icon_state = "culthood"
	desc = "一个撕裂、沾满灰尘的兜帽。内衬有奇怪的文字。"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEEARS
	flags_cover = HEADCOVERSEYES
	armor_type = /obj/item/clothing/suit/hooded/cultrobes::armor_type
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_TEMP_PROTECT

/**
 * "Alt" robes
 * Given by Arming Aura blood magic.
 * Essentially the base armor, but with a different sprite.
 * No idea why this exists tbh.
 */
/obj/item/clothing/suit/hooded/cultrobes/alt
	name = "教徒长袍"
	desc = "一套由纳尔之嗣追随者穿着的装甲长袍。"
	icon_state = "cultrobesalt"
	inhand_icon_state = null
	hoodtype = /obj/item/clothing/head/hooded/cult_hoodie/alt

/obj/item/clothing/head/hooded/cult_hoodie/alt
	name = "教徒兜帽"
	desc = "一个由纳尔之嗣追随者穿着的装甲兜帽。"
	icon_state = "cult_hoodalt"
	inhand_icon_state = null

///'Ghost' subtype, given to cultists spawned by Spirit Realm. Can't be dropped.
/obj/item/clothing/suit/hooded/cultrobes/alt/ghost
	item_flags = DROPDEL

/obj/item/clothing/suit/hooded/cultrobes/alt/ghost/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CULT_TRAIT)

/**
 * 'Hardened' cultist armor.
 * Given by the daemon forge, is the main armor cultists have access to.
 * Good defense stats, protects against space and temperature, has effects on non-cultists whom use it.
 */
/obj/item/clothing/suit/hooded/cultrobes/hardened
	name = "\improper 纳尔'西恩硬化护甲"
	desc = "一套由纳尔之嗣教派战士穿着的重型装甲外骨骼。它能承受硬真空环境。"
	icon_state = "cult_armor"
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_BULKY
	allowed = list(/obj/item/tome, /obj/item/melee/cultblade, /obj/item/tank/internals)
	armor_type = /datum/armor/cultrobes_hardened
	hoodtype = /obj/item/clothing/head/hooded/cult_hoodie/hardened
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL
	flags_inv = HIDEGLOVES | HIDEJUMPSUIT
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	resistance_flags = NONE

/obj/item/clothing/suit/hooded/cultrobes/hardened/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_BIBLE_SMACKED, PROC_REF(on_bible_smacked))

/obj/item/clothing/suit/hooded/cultrobes/hardened/proc/on_bible_smacked(obj/item/book/bible/source, mob/user)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(attempt_exorcism), user)
	return COMSIG_END_BIBLE_CHAIN

/**
 * attempt_exorcism: called from on_bible_smacked, takes time and if successful
 * turns into a new set of chaplain clothes
 *
 * Arguments:
 * * exorcist: user who is attempting to remove the spirit
 */
/obj/item/clothing/suit/hooded/cultrobes/hardened/proc/attempt_exorcism(mob/living/exorcist)
	if(IS_CULTIST(exorcist))
		return
	balloon_alert(exorcist, "驱魔中...")
	playsound(src, 'sound/effects/hallucinations/veryfar_noise.ogg', 40, TRUE)
	if(!do_after(exorcist, 4 SECONDS, target = src))
		return
	playsound(src, 'sound/effects/pray_chaplain.ogg', 60, TRUE)

	exorcist.visible_message(span_notice("[exorcist]净化了[src]！"))
	var/new_item_path = GLOB.holy_armor_type || pick(subtypesof(/obj/item/storage/box/holy))
	var/obj/item/new_item = new new_item_path()
	//take everything out and delete the box.
	for(var/obj/item/storage_items as anything in new_item.contents)
		storage_items.forceMove(get_turf(src))
	qdel(new_item)
	qdel(src)

/datum/armor/cultrobes_hardened
	melee = 50
	bullet = 40
	laser = 50
	energy = 60
	bomb = 50
	bio = 100
	fire = 100
	acid = 100

/obj/item/clothing/suit/hooded/cultrobes/hardened/equipped(mob/living/user, slot)
	. = ..()
	if(slot_flags & slot)
		START_PROCESSING(SSprocessing, src)

/obj/item/clothing/suit/hooded/cultrobes/hardened/dropped(mob/living/user)
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/item/clothing/suit/hooded/cultrobes/hardened/process(seconds_per_tick)
	var/mob/living/carbon/wearer = loc
	if(!istype(wearer) || IS_CULTIST(wearer))
		return
	if(!SPT_PROB(15, seconds_per_tick))
		return
	var/obj/item/bodypart/bone_to_wound = pick(wearer.get_bodyparts())
	var/wound_type = pick(list(
		/datum/wound/blunt/bone/moderate,
		/datum/wound/pierce/bleed/moderate,
	))
	var/datum/wound/wound_of_choice = new wound_type()
	wound_of_choice.apply_wound(bone_to_wound, wound_source = "cultist robes")
	to_chat(wearer, span_alert("[src]开始发光，你突然发现自己浑身是伤！"))

/obj/item/clothing/head/hooded/cult_hoodie/hardened
	name = "\improper 纳尔'西恩硬化头盔"
	desc = "一个由纳尔之嗣教派战士穿着的重型装甲头盔。它能承受硬真空环境。"
	icon_state = "cult_helmet"
	inhand_icon_state = null
	armor_type = /obj/item/clothing/suit/hooded/cultrobes/hardened::armor_type
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | SNUG_FIT | STACKABLE_HELMET_EXEMPT | HEADINTERNALS
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	flash_protect = FLASH_PROTECTION_WELDER
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	resistance_flags = NONE

/**
 * Shielded armor
 * Was removed from the game, but returns as an exclusive to deathmatch
 * Gives the user a shield that can protect from a certain amount of damage before needing
 * to recharge.
 */
/obj/item/clothing/suit/hooded/cultrobes/cult_shield
	name = "强化邪教徒护甲"
	desc = "能围绕使用者生成强力护盾的强化护甲。"
	icon_state = "cult_armor"
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_BULKY
	armor_type = /datum/armor/cultrobes_cult_shield
	hoodtype = /obj/item/clothing/head/hooded/cult_hoodie/cult_shield

/datum/armor/cultrobes_cult_shield
	melee = 50
	bullet = 40
	laser = 50
	energy = 50
	bomb = 50
	bio = 30
	fire = 50
	acid = 60

/obj/item/clothing/suit/hooded/cultrobes/cult_shield/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/shielded, \
		recharge_start_delay = 0 SECONDS, \
		shield_icon_file = 'icons/effects/cult.dmi', \
		shield_icon = "shield-cult", \
		run_hit_callback = CALLBACK(src, PROC_REF(shield_damaged)), \
	)

/obj/item/clothing/suit/hooded/cultrobes/cult_shield/equipped(mob/living/user, slot)
	..()
	if(!IS_CULTIST(user))
		to_chat(user, span_cult_large("我不建议你这么做。"))
		to_chat(user, span_warning("一阵强烈的恶心感压倒了你！"))
		user.dropItemToGround(src, TRUE)
		user.set_dizzy_if_lower(1 MINUTES)
		user.Paralyze(100)

///Callback when the shield breaks, since cult robes are stupid and have different effects.
/obj/item/clothing/suit/hooded/cultrobes/cult_shield/proc/shield_damaged(mob/living/wearer, attack_text, new_current_charges)
	wearer.visible_message(span_danger("[wearer]的长袍在一阵血红色火花中中和了[attack_text]！"))
	new /obj/effect/temp_visual/cult/sparks(get_turf(wearer))
	if(new_current_charges == 0)
		wearer.visible_message(span_danger("[wearer]周围的符文护盾突然消失了！"))

/obj/item/clothing/head/hooded/cult_hoodie/cult_shield
	name = "强化邪教徒头盔"
	desc = "能围绕使用者生成强力护盾的强化头盔。"
	icon_state = "cult_hoodalt"
	armor_type = /obj/item/clothing/suit/hooded/cultrobes/cult_shield::armor_type

/**
 * Zealot's blindfold
 * Version of night vision health HUDs that only cultists can use.
 * Will deal eye damage overtime to non-cultists.
 */
/obj/item/clothing/glasses/hud/health/night/cultblind
	name = "狂热者眼罩"
	desc = "愿纳尔'西指引你穿越黑暗，庇护你免受光明侵扰。"
	icon_state = "blindfold"
	inhand_icon_state = "blindfold"
	flags_cover = GLASSESCOVERSEYES
	flash_protect = FLASH_PROTECTION_WELDER
	actions_types = null
	color_cutoffs = list(40, 0, 0) //red
	glass_colour_type = null
	custom_materials = null

/obj/item/clothing/glasses/hud/health/night/cultblind/equipped(mob/living/user, slot)
	. = ..()
	if(slot_flags & slot)
		START_PROCESSING(SSprocessing, src)

/obj/item/clothing/glasses/hud/health/night/cultblind/dropped(mob/living/user)
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/item/clothing/glasses/hud/health/night/cultblind/process(seconds_per_tick)
	var/mob/living/carbon/wearer = loc
	if(!istype(wearer) || IS_CULTIST(wearer))
		return
	var/obj/item/organ/eyes/eyes = wearer.get_organ_slot(ORGAN_SLOT_EYES)
	if(!eyes)
		return
	if(!eyes.apply_organ_damage(1))
		return
	if(SPT_PROB(3, seconds_per_tick))
		to_chat(wearer, span_danger("你感觉[src]正刺入你的眼睛，将[eyes.p_them()]烧灼殆尽！"))
