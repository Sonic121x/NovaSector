/obj/item/clothing/suit/hooded/cloak/godslayer
	name = "弑神者护甲"
	icon_state = "godslayer"
	desc = "一套由骑士盔甲残骸与温迪戈部件打造而成的护甲。"
	armor_type = /datum/armor/cloak_godslayer
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/godslayer
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	resistance_flags = FIRE_PROOF | ACID_PROOF | FREEZE_PROOF
	transparent_protection = HIDEGLOVES|HIDESUITSTORAGE|HIDEJUMPSUIT|HIDESHOES
	/// Amount to heal when the effect is triggered
	var/heal_amount = 500
	/// Time until the effect can take place again
	var/effect_cooldown_time = 10 MINUTES
	/// Current cooldown for the effect
	COOLDOWN_DECLARE(effect_cooldown)
	var/static/list/damage_heal_order = list(BRUTE, BURN, OXY)

/datum/armor/cloak_godslayer
	melee = 70
	bullet = 50
	laser = 30
	energy = 40
	bomb = 50
	bio = 50
	fire = 100
	acid = 100
	wound = 10

/obj/item/clothing/suit/hooded/cloak/godslayer/Initialize(mapload)
	. = ..()
	allowed = GLOB.mining_suit_allowed
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_ARMOR_RUSTLE, 8)

/obj/item/clothing/suit/hooded/cloak/godslayer/examine(mob/user)
	. = ..()
	if(loc == user && !COOLDOWN_FINISHED(src, effect_cooldown))
		. += "You feel like the revival effect will be able to occur again in [COOLDOWN_TIMELEFT(src, effect_cooldown) / 10] seconds."

/obj/item/clothing/suit/hooded/cloak/godslayer/equipped(mob/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_OCLOTHING)
		RegisterSignal(user, COMSIG_MOB_STATCHANGE, PROC_REF(resurrect))
		return
	UnregisterSignal(user, COMSIG_MOB_STATCHANGE)

/obj/item/clothing/suit/hooded/cloak/godslayer/dropped(mob/user)
	..()
	UnregisterSignal(user, COMSIG_MOB_STATCHANGE)

/obj/item/clothing/suit/hooded/cloak/godslayer/proc/resurrect(mob/living/carbon/user, new_stat)
	SIGNAL_HANDLER
	if(new_stat > CONSCIOUS && new_stat < DEAD && COOLDOWN_FINISHED(src, effect_cooldown))
		COOLDOWN_START(src, effect_cooldown, effect_cooldown_time) //This needs to happen first, otherwise there's an infinite loop
		user.heal_ordered_damage(heal_amount, damage_heal_order)
		user.visible_message(span_notice("[user]突然复活，其盔甲上翻涌着恶魔能量！"), span_notice("你突然感到精力充沛！"))
		playsound(user.loc, 'sound/effects/magic/clockwork/ratvar_attack.ogg', 50)

/obj/item/clothing/head/hooded/cloakhood/godslayer
	name = "弑神者头盔"
	icon = 'icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'icons/mob/clothing/head/helmet.dmi'
	icon_state = "godslayer"
	desc = "温迪戈的犄角与头骨，由一位恶魔矿工残留的冰寒能量维系在一起。"
	armor_type = /datum/armor/cloak_godslayer
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | SNUG_FIT
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	flash_protect = FLASH_PROTECTION_WELDER
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	resistance_flags = FIRE_PROOF | ACID_PROOF | FREEZE_PROOF
