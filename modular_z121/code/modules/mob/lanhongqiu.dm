/datum/loadout_item/inhand/pet/lanhongqiu
	name = "蓝红球"
	item_path = /obj/item/mob_holder/pet/donator/lanhongqiu
	ckeywhitelist = list("lanhongqiu")

/obj/item/lanhongqiucore
	name = "蓝红球的核心"
	desc = "你怎么敢的！这可不是在杀史莱姆，你杀死了一个和你一样有思想感情的生物！"
	icon = 'modular_z121/icons/mob/pets.dmi'
	icon_state = "lanhongqiu_core"

/mob/living/basic/pet/lanhongqiu
	name = "蓝红球"
	desc = "克罗托生物，也许别人会认为是史莱姆的变种，实际是他们已经在当地建立了一个庞大的世界国家。别惹他！这是世界共和国的公民！"
	gender = MALE
	icon = 'modular_z121/icons/mob/pets.dmi'
	held_lh = 'modular_z121/icons/mob/pets_held_lh.dmi'
	held_rh = 'modular_z121/icons/mob/pets_held_rh.dmi'
	icon_state = "lanhongqiu"
	icon_living = "lanhongqiu"
	icon_dead = "lanhongqiu_dead"
	held_state = "lanhongqiu"
	melee_damage_lower = 0
	melee_damage_upper = 0
	can_be_held = TRUE
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	minimum_survivable_temperature = NPC_DEFAULT_MIN_TEMP
	maximum_survivable_temperature = NPC_DEFAULT_MAX_TEMP
	maxHealth = 100
	health = 100
	var/datum/action/cooldown/mob_cooldown/charge/basic_charge/dodgeroll/charge
	var/charge_type = /datum/action/cooldown/mob_cooldown/charge/basic_charge/dodgeroll
	butcher_results = list(/obj/item/lanhongqiucore = 1)
	unsuitable_atmos_damage = 0.5
	mobility_flags = MOBILITY_FLAGS_REST_CAPABLE_DEFAULT
	obj_damage = 0
	var/obj/item/skysword/weapon

/obj/item/mob_holder/pet/donator/lanhongqiu
	name = "蓝红球"
	desc = "克罗托生物，也许别人会认为是史莱姆的变种，实际是他们已经在当地建立了一个庞大的世界国家。别惹他！这是世界共和国的公民！"
	icon = 'modular_z121/icons/mob/pets.dmi'
	icon_state = "lanhongqiu"

	starting_pet = /mob/living/basic/pet/lanhongqiu

/mob/living/basic/pet/lanhongqiu/Initialize(mapload)
	. = ..()
	charge = new charge_type(src)
	charge.Grant(src)

/datum/action/cooldown/mob_cooldown/charge/basic_charge/dodgeroll
	cooldown_time = 5 SECONDS
	charge_delay = 0.1 SECONDS
	charge_past = 0
	charge_distance = 2
	charge_damage = 0
	destroy_objects = FALSE

/datum/action/cooldown/mob_cooldown/charge/basic_charge/dodgeroll/do_charge(atom/movable/charger, atom/target_atom, delay, past)
	. = ..()
	if(!isliving(charger))
		return
	ADD_TRAIT(charger,TRAIT_UNHITTABLE_BY_PROJECTILES,REF(src))
	charger.SpinAnimation(FLIP_EMOTE_DURATION, 1)
	addtimer(TRAIT_CALLBACK_REMOVE(charger,TRAIT_UNHITTABLE_BY_PROJECTILES,REF(src)), TAUNT_EMOTE_DURATION * 1)

/mob/living/basic/pet/lanhongqiu/UnarmedAttack(atom/A)
	. = ..()
	if(!isitem(A))
		return

	if(!weapon && istype(A, /obj/item/skysword))
		visible_message(span_notice("[src] 拿起了 [A]."), span_notice("你拿起了 [A]."))
		weapon = A
		weapon.forceMove(src)
		melee_damage_lower = 18
		melee_damage_upper = 22
		armour_penetration = 0
		wound_bonus = CANT_WOUND
		update_icons()
	else if(!weapon && !istype(A, /obj/item/spear))
		to_chat(src, span_warning("You do not know how to wield the [A]!"))

/mob/living/basic/pet/lanhongqiu/update_icons()
	. = ..()
	if(stat == DEAD)
		return
	icon_state = weapon ? initial(icon_state) + "_sword" : initial(icon_state)

/mob/living/basic/pet/lanhongqiu/death(gibbed)
	if(weapon)
		weapon.forceMove(get_turf(src))
		weapon = null
	update_icons()
	. = ..()

/obj/item/skysword
	name = "天武剑"
	desc = "这是天地文武大将军曾经的武器，剑身黑，泛银光，削铁如泥，千年不锈。祂曾经用这把利剑杀尽王侯，使天下太平。很遗憾，这把剑只能被蓝红球使用，并且由于世界共和国文物保护协议的规定，此剑已被追踪。你最好在文物保护官员和共和国战斗队到来之前联系官方并归还。"
	icon = 'modular_z121/icons/mob/pets.dmi'
	icon_state = "skysword"

/datum/market_item/misc/skysword
	name = "天武剑"
	desc = "这是天地文武大将军曾经的武器，剑身黑，泛银光，削铁如泥，千年不锈。祂曾经用这把利剑杀尽王侯，使天下太平。很遗憾，这把剑只能被蓝红球使用。"
	item = /obj/item/skysword
	price_min = CARGO_CRATE_VALUE * 3
	price_max = CARGO_CRATE_VALUE * 5
	stock_max = 1
	availability_prob = 90
